Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623Ab3EVWM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:12:58 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:47054 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757538Ab3EVWM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:12:56 -0400
MIME-Version: 1.0
In-Reply-To: <20130522205704.GB12923@phenom.dumpdata.com>
References: <1365692161-13735-1-git-send-email-dgdegra@tycho.nsa.gov>
 <20130522191551.GB10617@phenom.dumpdata.com> <CAM0nabGSo9b7q1pGOsTGjFzJBi7cK=2s5mGmOgNjeAf-2+ZvDQ@mail.gmail.com>
 <20130522205704.GB12923@phenom.dumpdata.com>
From: Kent Yoder <shpedoikal@gmail.com>
Date: Wed, 22 May 2013 17:12:24 -0500
Message-ID: <CAM0nabFO_tTqsX5c7Q-Z14CbRnqo9m11f__xkfzt6c8M026D_A@mail.gmail.com>
Subject: Re: [tpmdd-devel] [PATCH v2] drivers/tpm: add xen tpmfront interface
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: leosilva@linux.vnet.ibm.com, adlai@linux.vnet.ibm.com,
        Daniel De Graaf <dgdegra@tycho.nsa.gov>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        TPM Device Driver List <tpmdd-devel@lists.sourceforge.net>,
        Ian.Campbell@citrix.com, Jan Beulich <JBeulich@suse.com>,
        xen-devel@lists.xen.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 3:57 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Wed, May 22, 2013 at 02:47:01PM -0500, Kent Yoder wrote:
>> >> +     notify_remote_via_evtchn(priv->evtchn);
>> >> +
>> >> +     ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
>> >
>> > Um, + 6? Why? Is there an #define for that magic constant?
>> > Should this value be read before you do the wait_for_tpm_stat stuff?
>>
>>   This is hardcoded to 6 even in tpm.c.  Time for a #define...
>>
>> > Otherwise it looks OK to me. Should this go through me or Kent?
>> > And if so, is Kent waiting for my feedback?
>>
>>   My comments were minor -- I was expecting feedback on your earlier
>> comments before merging.  I think this should go through the tpmdd
>> maintainer if its going to live in drivers/char/tpm though.
>
> That is you I thought?
>
> konrad@phenom:~/mm$ scripts/get_maintainer.pl -f drivers/char/tpm
> Kent Yoder <key@linux.vnet.ibm.com> (maintainer:TPM DEVICE DRIVER)
> Rajiv Andrade <mail@srajiv.net> (maintainer:TPM DEVICE DRIVER)
> Marcel Selhorst <tpmdd@selhorst.net> (maintainer:TPM DEVICE DRIVER)
> Sirrix AG <tpmdd@sirrix.com> (maintainer:TPM DEVICE DRIVER)
> tpmdd-devel@lists.sourceforge.net (moderated list:TPM DEVICE DRIVER)
> linux-kernel@vger.kernel.org (open list)

That was me until today. :-)  But I didn't see the response your comments yet.

Kent
