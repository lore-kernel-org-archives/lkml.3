Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbaAFRad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 12:30:33 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:65505 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401AbaAFRac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 12:30:32 -0500
MIME-Version: 1.0
In-Reply-To: <20140106170855.GA1828@mguzik.redhat.com>
References: <1389022230-24664-1-git-send-email-wroberts@tresys.com>
	<1389022230-24664-3-git-send-email-wroberts@tresys.com>
	<20140106170855.GA1828@mguzik.redhat.com>
Date: Mon, 6 Jan 2014 09:30:31 -0800
Message-ID: <CAFftDdpoV9S5VO6Ozt3nOF+bnJDeomeOR5k8ri8eRBm3JrkXGQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 3/3] audit: Audit proc cmdline value
From: William Roberts <bill.c.roberts@gmail.com>
To: Mateusz Guzik <mguzik@redhat.com>
Cc: "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Guy Briggs <rgb@redhat.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        akpm@linux-foundation.org, Stephen Smalley <sds@tycho.nsa.gov>,
        William Roberts <wroberts@tresys.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 6, 2014 at 9:08 AM, Mateusz Guzik <mguzik@redhat.com> wrote:
> I can't comment on the concept, but have one nit.

FYI: The concept is something that has been in the works and at least ackd on
by the current maintainer of audit:
http://marc.info/?l=linux-kernel&m=138660320704580&w=2

>
> On Mon, Jan 06, 2014 at 07:30:30AM -0800, William Roberts wrote:
>> +static void audit_log_cmdline(struct audit_buffer *ab, struct task_struct *tsk,
>> +                      struct audit_context *context)
>> +{
>> +     int res;
>> +     char *buf;
>> +     char *msg = "(null)";
>> +     audit_log_format(ab, " cmdline=");
>> +
>> +     /* Not  cached */
>> +     if (!context->cmdline) {
>> +             buf = kmalloc(PATH_MAX, GFP_KERNEL);
>> +             if (!buf)
>> +                     goto out;
>> +             res = get_cmdline(tsk, buf, PATH_MAX);
>> +             /* Ensure NULL terminated */
>> +             if (buf[res-1] != '\0')
>> +                     buf[res-1] = '\0';
>
> This accesses memory below the buffer if get_cmdline returned 0, which I
> believe will be the case when someone jokingly unmaps the area (all
> maybe when it is swapped out but can't be swapped in due to I/O errors).
>

Yeah that's not a nit, that's a serious issue and I will correct. Thanks.

> Also since you are just putting 0 in there anyway I don't see much point
> in testing for it.
>
>> +             context->cmdline = buf;
>> +     }
>> +     msg = context->cmdline;
>> +out:
>> +     audit_log_untrustedstring(ab, msg);
>> +}
>> +
>
>
>
> --
> Mateusz Guzik



-- 
Respectfully,

William C Roberts
