Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161866Ab3DEOiM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 10:38:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49506 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161562Ab3DEOiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 10:38:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [char-misc-next] mei: add debugfs hooks
Date: Fri, 5 Apr 2013 16:38:05 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
References: <1365171789-21288-1-git-send-email-tomas.winkler@intel.com>
In-Reply-To: <1365171789-21288-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304051638.05292.arnd@arndb.de>
X-Provags-ID: V02:K0:3bqKyRvDojavWCK5qXA9A3mclUwQCB9fg4fYlb2SXL0
 YvLG2qZJX3k6boX3KHYs5JxMsmSbSB7ZkJonE1bRwpZMsvd29p
 wRjyI0LhNNFUr7o1OhvGzy4IGd+fhWEafyghqq3zCwTlkJxUbe
 f+GTwVte2usX1U1bc+K9evKAFOqO3XNcuiGN5xlRh9vWqNGhk2
 IuFo27jag9/atGOidNKYm/Bcc8zqEbU9lPBfU03fG5TkoURFb9
 D3bQDY9qUk0F3kKd+rt4tw6uuUPH7TZGE9L2Y3xtMFKpbdAOfu
 BYqePgcWOnQ+vClFUVRkToOkyFaTSykk7tAjRbN2Wo2URK/bn3
 Gw8TOqBP1oJEAw8WypUI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 April 2013, Tomas Winkler wrote:
> debugfs exposes device state and list of me clients and their
> properties
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
> V2:
> 1. don't use DEBUGFS_ADD_FILE macro
> 2. compile debugfs.c only if CONFIG_DEBUG_FS is set

Acked-by: Arnd Bergmann <arnd@arndb.de>
> +#define DEBUGFS_ADD_FILE(_mei, name, parent, mode)	\
> +	debugfs_create_file(#name, mode, parent,	\
> +			_mei, &mei_dbgfs_fops_##name)

It seems you removed all the users but left the definition in place.

	Arnd
