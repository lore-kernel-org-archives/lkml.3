Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167AbaGVWLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:11:53 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:56340 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757139AbaGVWLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:11:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJxEJQ5+05O-Q=W652O-fZ1WBVsUjb3d2JEwAAMF=fx-Q@mail.gmail.com>
References: <1405373897-31671-1-git-send-email-keescook@chromium.org>
 <1405373897-31671-4-git-send-email-keescook@chromium.org> <20140714222419.GC10393@wotan.suse.de>
 <CAGXu5j+V807cyDdyEzoRzSjYEyhkDntaEkKOx6n=OzUoF31-sA@mail.gmail.com>
 <CAB=NE6WnP-7YCr8DzCq-HOLZVuQxmCa+nwN7kQBxTnUHK+xMRg@mail.gmail.com> <CAGXu5jJxEJQ5+05O-Q=W652O-fZ1WBVsUjb3d2JEwAAMF=fx-Q@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Tue, 22 Jul 2014 15:11:27 -0700
X-Google-Sender-Auth: Xs5yPPbR1NE3uOUJOwlSsa0mhKQ
Message-ID: <CAB=NE6VMca9gkvino-_SbThX3DgNSMJ+x-AkmyPR-G-x4Pq_jA@mail.gmail.com>
Subject: Re: [PATCH 3/7] security: introduce kernel_fw_from_file hook
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <james.l.morris@oracle.com>,
        David Howells <dhowells@redhat.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-firmware@kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 1:55 PM, Kees Cook <keescook@chromium.org> wrote:
> On Tue, Jul 22, 2014 at 12:39 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
>> On Mon, Jul 14, 2014 at 3:31 PM, Kees Cook <keescook@chromium.org> wrote:
>>> Yup, with this and the module hook, adding a similar hook for kexec
>>> makes sense as well. A paranoid kernel doesn't want to trust anything
>>> it's loading from userspace. :)
>>
>> Well I'm actually wondering if we could generalize requiring hooks or
>> not for LSM as part of the general kobject definition. Then we
>> wouldn't need to keep growing hooks for modules, firmware, kexec
>> images, etc, but instead using the interfaces for kobjects and who
>> depend on them. How that would actually look -- I'm not sure, but just
>> a thought.
>
> Yeah, there does seem to be a repeated "get a thing from userspace"
> method here, but the interfaces have been rather scattered so far. I
> haven't seen an obvious way to consolidate them yet.

If we are going to be adding a new system call for each type of
userspace object to help LSMs with requirements I wonder if its a
worthy endeavor to review. This series didn't add one but you had
mentioned finit_module() for example, are we going to want one for
finit_firmware() finit_kexec_image(), etc?

 Luis
