Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbaGBRJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 13:09:50 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:55442 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756670AbaGBRJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 13:09:47 -0400
MIME-Version: 1.0
In-Reply-To: <1871630.hB3tXi0r3a@sifl>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
 <1404124096-21445-10-git-send-email-drysdale@google.com> <CALCETrUBCL1jKfooLaqrJCb-uYrMwYPQL2v-M04NTVf2LoD_fw@mail.gmail.com>
 <1871630.hB3tXi0r3a@sifl>
From: David Drysdale <drysdale@google.com>
Date: Wed, 2 Jul 2014 18:09:27 +0100
Message-ID: <CAHse=S_wZez=XOfGwkCCWXGMAFj3ivbL9g93RX66bOw3cYw1kQ@mail.gmail.com>
Subject: Re: [PATCH 09/11] capsicum: implementations of new LSM hooks
To: Paul Moore <paul@paul-moore.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        LSM List <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 2, 2014 at 2:49 PM, Paul Moore <paul@paul-moore.com> wrote:
> On Monday, June 30, 2014 09:05:38 AM Andy Lutomirski wrote:
>> On Mon, Jun 30, 2014 at 3:28 AM, David Drysdale <drysdale@google.com> wrote:
>> > If the LSM does not provide implementations of the .file_lookup and
>> > .file_install LSM hooks, always use the Capsicum implementations.
>> >
>> > The Capsicum implementation of file_lookup checks for a Capsicum
>> > capability wrapper file and unwraps to if the appropriate rights
>> > are available.
>> >
>> > The Capsicum implementation of file_install checks whether the file
>> > has restricted rights associated with it.  If it does, it is replaced
>> > with a Capsicum capability wrapper file before installation into the
>> > fdtable.
>>
>> I think I fall on the "no LSM" side of the fence.  This kind of stuff
>> should be available regardless of selected LSM (as it is in your
>> code) ...
>
> I agree.  Looking quickly at the patches, the code seems to take an odd
> approach of living largely outside the LSM framework, but then relying on a
> couple of LSM hooks.  Capsicum should either live fully as a LSM or fully
> outside of it, this mix seems a bit silly to me.

Yeah, the end result was definitely a bit odd, hence the queries in the
cover email.  The consensus so far seems to be that they don't help,
so I'll remove the gratuitous LSM hooks on the next iteration.

Thanks,
David

> --
> paul moore
> www.paul-moore.com
>
