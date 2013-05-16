Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab3EPTIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 15:08:40 -0400
Received: from canardo.mork.no ([148.122.252.1]:48491 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959Ab3EPTIi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 15:08:38 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: Re: net: cdc_ncm, cdc_mbim: allow user to prefer NCM for backwards compatibility
Organization: m
References: <20130516182510.GA4728@redhat.com>
Date: Thu, 16 May 2013 21:08:23 +0200
In-Reply-To: <20130516182510.GA4728@redhat.com> (Dave Jones's message of "Thu,
	16 May 2013 14:25:10 -0400")
Message-ID: <87mwrueo9k.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> writes:

> Hi Bjørn,
>
>  > Gitweb:     http://git.kernel.org/linus/;a=commit;h=1e8bbe6cd02fc300c88bd48244ce61ad9c7d1776
>  > Commit:     1e8bbe6cd02fc300c88bd48244ce61ad9c7d1776
>  > Parent:     a5b8db91442fce9c9713fcd656c3698f1adde1d6
>  > Author:     Bjørn Mork <bjorn@mork.no>
>  > AuthorDate: Thu Mar 14 01:05:13 2013 +0000
>  > Committer:  David S. Miller <davem@davemloft.net>
>  > CommitDate: Sun Mar 17 11:59:03 2013 -0400
>  > 
>  >     net: cdc_ncm, cdc_mbim: allow user to prefer NCM for backwards compatibility
>  >     
>  >     commit bd329e1 ("net: cdc_ncm: do not bind to NCM compatible MBIM devices")
>  >     introduced a new policy, preferring MBIM for dual NCM/MBIM functions if
>  >     the cdc_mbim driver was enabled.  This caused a regression for users
>  >     wanting to use NCM.
>  >     
>  >     Devices implementing NCM backwards compatibility according to section
>  >     3.2 of the MBIM v1.0 specification allow either NCM or MBIM on a single
>  >     USB function, using different altsettings.  The cdc_ncm and cdc_mbim
>  >     drivers will both probe such functions, and must agree on a common
>  >     policy for selecting either MBIM or NCM.  Until now, this policy has
>  >     been set at build time based on CONFIG_USB_NET_CDC_MBIM.
>  >     
>  >     Use a module parameter to set the system policy at runtime, allowing the
>  >     user to prefer NCM on systems with the cdc_mbim driver.
>
> Is there any way we can set this automatically based on the type of device connected
> and have it just work without users needing to edit modprobe.conf ?
>
> Since this change, we've now getting reports like https://bugzilla.redhat.com/show_bug.cgi?id=963663

Yes, this is a very unfortunate side effect of the userspace/kernel
split of the MBIM driver combined with the NCM/MBIM "backwards
compatibility" setting.  Which in itself is a bad idea, IMHO.

I recommend all distros do the same as Debian: Set NCM as default until
a userspace application with MBIM support is ready and packaged in the
distro:
http://anonscm.debian.org/viewvc/kernel/dists/trunk/linux/debian/patches/debian/cdc_ncm-cdc_mbim-use-ncm-by-default.patch

FWIW, I wish we would have thought about this issue before v3.8 was
released.  Then we could have made that patch the mainline default,
without that being a userspace API change.  But we didn't.

The good news is that Aleksander has done some nice work on the MBIM
support in ModemManager, so there is a good chance that the next release
will make this problem go away.



Bjørn
