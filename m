Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223AbaAUVo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:44:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64735 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932213AbaAUVov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:44:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 20/73] arm: use subsys_initcall in non-modular pl320 IPC code
Date: Tue, 21 Jan 2014 22:44:21 +0100
Message-ID: <4922482.oeJaTIvZxl@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <1390339396-3479-21-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com> <1390339396-3479-21-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:c/JaMklHClpI8Z/4kLFA1upCXXlYvz72Jop07C6J2f+
 /LP2/IESKcYoU/RSj2XVBkcytTaq2784ArhtwE/XVy+L+PpoSf
 kWRy8Zr0SYcwGw/PQMmjXCd0RiSZS2fUJlj5epeOVpcdflz5Sw
 QUIFhQaoUsrdoopa8K634kDIAbJZ90T71jHy/oKKhK2DWMhbj7
 lE9blmvla7XDKU80EK//9/ro2evm95tifceEQJ+QfrEv+R/+1f
 pfZ8eWVghWOTqZLF5eIyH0gD4ARc5TMHLLLifaRSxbrd312W4D
 MtvrguecxI0RlYle3YERpnEQfY8kAei1nt7QkAmOkiKf8pYEOS
 D/QyB7m6WYjhhcGfo1Ug=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 January 2014 16:22:23 Paul Gortmaker wrote:
> 
> Note that direct use of __initcall is discouraged, vs. one
> of the priority categorized subgroups.  As __initcall gets
> mapped onto device_initcall, our use of subsys_initcall (which
> seems to make sense for netfilter code) will thus change this
> registration from level 6-device to level 4-subsys (i.e. slightly
> earlier).  However no impact of that small difference is expected.

This doesn't have anything to do with netfilter. The only user
of this driver at the moment is the highbank cpufreq driver, but
that could change.

	Arnd
