Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab3FYVgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 17:36:53 -0400
Received: from mail-vb0-f45.google.com ([209.85.212.45]:65382 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab3FYVgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 17:36:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130625201705.GA15966@redhat.com>
References: <0e00e9073855c02a382d49ba1ede9c4fda3451b7.1372189875.git.luto@amacapital.net>
 <20130625201602.GB1726@moon> <20130625201705.GA15966@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 25 Jun 2013 14:36:31 -0700
Message-ID: <CALCETrVxm2wHvLgexG6fZO+h1rNHC_qDCv6B+4XuANHgSQU4iw@mail.gmail.com>
Subject: Re: [PATCH] proc: Expose /proc/<pid>/task/<tid>/children unconditionally
To: Oleg Nesterov <oleg@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 1:17 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 06/26, Cyrill Gorcunov wrote:
>>
>> On Tue, Jun 25, 2013 at 12:51:45PM -0700, Andy Lutomirski wrote:
>> > This is currently only available if CONFIG_CHECKPOINT_RESTORE, which
>> > is hidden under CONFIG_EXPERT.  It's generally useful functionality,
>> > though, so expose it unconditionally.
>> >
>> > Cc: Cyrill Gorcunov <gorcunov@openvz.org>
>> > Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
>
> I didn't see the patch but I guess it is trivial and I agree with intent ;)

The patch works, but "children" is only listed under task/<tid>, not
under /proc/<pid>.  Is that intentional?  Fixing it would be a
one-liner.

--Andy
