Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115Ab3BFSZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 13:25:35 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:40086 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab3BFSZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 13:25:34 -0500
MIME-Version: 1.0
In-Reply-To: <20130204191334.GB14837@gmail.com>
References: <1356040315.3198.51.camel@shinybook.infradead.org>
	<tip-ffee0de411fd4f74f3b788892eeb075abbf26c52@git.kernel.org>
	<alpine.DEB.2.00.1212252222450.24528@chino.kir.corp.google.com>
	<1356564746.7010.56.camel@shinybook.infradead.org>
	<50DB9FA5.6070704@infradead.org>
	<alpine.DEB.2.02.1302041002430.6063@chino.kir.corp.google.com>
	<20130204184436.GA13256@gmail.com>
	<alpine.DEB.2.02.1302041053330.6063@chino.kir.corp.google.com>
	<20130204191408.GA32081@kroah.com>
	<20130204191334.GB14837@gmail.com>
Date: Wed, 6 Feb 2013 20:25:33 +0200
X-Google-Sender-Auth: WXGiNk0pXCcSi0ILzhNyS1GWAV4
Message-ID: <CAOJsxLFy7K0cY-8SH4dXs=agYqCN8wW0eC2tQxFxfV8cf7uWqg@mail.gmail.com>
Subject: Re: [patch] config: fix make kvmconfig
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Rientjes <rientjes@google.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        David Woodhouse <dwmw2@infradead.org>, Michal Marek <mmarek@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 4, 2013 at 9:13 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
>> On Mon, Feb 04, 2013 at 10:57:35AM -0800, David Rientjes wrote:
>> > On Mon, 4 Feb 2013, Ingo Molnar wrote:
>> >
>> > > >  arch/x86/Kconfig | 1 +
>> > > >  1 file changed, 1 insertion(+)
>> > > >
>> > > > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> > > > index 6979498..f9459b3 100644
>> > > > --- a/arch/x86/Kconfig
>> > > > +++ b/arch/x86/Kconfig
>> > > > @@ -606,6 +606,7 @@ config KVMTOOL_TEST_ENABLE
>> > > >         select NETWORK_FILESYSTEMS
>> > > >         select INET
>> > > >         select EXPERIMENTAL
>> > > > +       select TTY
>> > > >         select SERIAL_8250
>> > > >         select SERIAL_8250_CONSOLE
>> > > >         select IP_PNP
>> > >
>> > > There's no 'config TTY' in the kernel AFAICS.
>> > >
>> >
>> > It's added in linux-next by 4f73bc4dd3e8 ("tty: Added a CONFIG_TTY option
>> > to allow removal of TTY").
>> >
>> > Adding Greg to the cc to figure out which tree this should be merged
>> > through.  Greg, please find the patch inline.
>>
>> Ideally it would go through my tree, but it can't because
>> KVMTOOL_TEST_ENABLE isn't in my tree :(
>>
>> I suggest just adding it to whatever tree this change is in,
>> it doesn't "hurt" to enable a config option that isn't in the
>> tree at the moment, right?  Or will Kconfig complain about it?
>
> Yeah, that's a good idea - I think Pekka can apply that change
> just fine to help anyone doing merges - I don't think kconfig
> treats it as a fatal error.

Applied, thanks guys!
