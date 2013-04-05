Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161183Ab3DEMPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 08:15:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62294 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab3DEMPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 08:15:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [char-misc-next] mei: add debugfs hooks
Date: Fri, 5 Apr 2013 14:15:02 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
References: <1365119491-10467-1-git-send-email-tomas.winkler@intel.com>
In-Reply-To: <1365119491-10467-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304051415.03122.arnd@arndb.de>
X-Provags-ID: V02:K0:cQLIexvlnuKFxE9mqvN3ZFVFpQ2dTZ5xDqXah+L/8rY
 IahG4Up0FOhqU0o/P9ne/mSordoUm83pbxufuYwwWrdVFZF2gk
 torGIAbbIQCol2A4rNJkh/GEus7emv9op0a1Qzr3Y0aAqSKH8j
 AWCYAPlQhRt+dFqMxnx4gd8rfXrl9z+9MnbQ/BdvDgHTtECClj
 TXYgjkr5naBC2/Eoqe1ihjmRmKSJxGmskjbR/jNEr7jo/Y4vwq
 8lQBLPsocohEbQZ8D3POkvaxrEAKnPxfp28SCv96kEqfzDsefK
 JD+hGIkv72qIHpZ+eo1/JTWbqDHEaXkGo4Z+4bhR8mON/WqVeY
 fW93X6y+voaHW8q2Eoqs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 April 2013, Tomas Winkler wrote:
> debugfs exposes device state and list of me clients and their
> properties
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Just one small comment:

> +#define DEBUGFS_ADD_FILE(_mei, name, parent, mode)	\
> +	debugfs_create_file(#name, mode, parent,	\
> +			_mei, &mei_dbgfs_fops_##name)


This macro seems to obfuscate more than it helps. In general, string concatenation
in macros is problematic because it means you can no longer grep for where a
symbols is being used.


	Arnd
