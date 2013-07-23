Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab3GWHYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:24:41 -0400
Received: from server19320154104.serverpool.info ([193.201.54.104]:37689 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab3GWHYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:24:39 -0400
Message-ID: <51EE2FA4.3020302@hauke-m.de>
Date: Tue, 23 Jul 2013 09:24:20 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the wireless-next tree
References: <20130723113245.a71f780b34193953a4a5cb45@canb.auug.org.au>
In-Reply-To: <20130723113245.a71f780b34193953a4a5cb45@canb.auug.org.au>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/23/2013 03:32 AM, Stephen Rothwell wrote:
> Hi John,
> 
> After merging the wireless-next tree, today's linux-next build
> (x86_64 allmodconfig) failed like this:
> 
> drivers/net/ethernet/broadcom/bgmac.c:19:27: fatal error:
> bcm47xx_nvram.h: No such file or directory #include
> <bcm47xx_nvram.h> ^
> 
> That file only exists for the MIPS architecture ...
> 
> Caused by commit 6ffdead8027c ("bcma: make it possible to select
> SoC support without mips").
> 
> I have used the version of the wireless-next tree from
> next-20130722 for today.

Thanks for spotting this. CONFIG_BGMAC should depend on
CONFIG_BCM47XX, I will send a patch for this to David Miller in the
evening.

Hauke
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJR7i+eAAoJEIZ0px9YPRMyxdMP/ixL8Dff/vZSXrncnWXGeBea
NgllYlmgPq44CyvPSYMi1WpsKBTOW2L3Yt8v7t/OJH4vDTQHrTxSbdtQFuFW9ZqN
+TTbmRkK4EgYyvnJ87RFAA0o6VWkho+oMMdQD88Nj9uBl38wSH2BoX9Dfe/4UPCt
xLS1TtrkNJOtwnu1crgh30aGUtX6Xw9AP201ySS6NElLuhulfHhx3pu3Y4ZiBPpW
sIKUYkpUvrqghKBvFdjy81iJxtdQ99ZYBHVrrTvAWfiV7WMCV8siGj6UDOi+ujgF
qzjMCy0Q4Bs4kL22XNDPTz+vFXRx45NoH7RJdPyV5Z6ylBVfAJZMSMMI5zqv08VG
ihnnyDDUlOGKcgBCoe2HpYDDIwV34WXKTNFNbzmQ2tgE9JntkfDxq6xr4cIS9FTL
iogNUJV32ColuansjkmAeeED6oy6QT7DcZYOMBXNcMHkRQGgt5/XfwYhVYTPWdsG
LuKxnw4RCnzWwL5hsghrtP2s9EPXsmWHf8BWtT+Ob8KmAx/rcnLZL2YDHd8uro0+
ZGZyqExkg9MFC3d+6goJd3E7BXEz/oytTUOBA7RuBsN7OlCVP2ixs1O4HtVwEi+/
o+5CXFKYAlY1+sOVy2lW/RRfZ8XrhUW3rP477HNnrri9bZKb5jvlw9Bb0C2ANDSL
JtW7+ofqPY7+m2xHNX76
=cySC
-----END PGP SIGNATURE-----
