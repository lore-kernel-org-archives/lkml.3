Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbaGVLeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:34:08 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:57998 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbaGVLeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:34:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Subject: Re: [PATCH 03/19] mfd: tps80031: Fix 'missing break or fall-through comment' warning
Date: Tue, 22 Jul 2014 13:33:29 +0200
Message-ID: <5230900.iFlbGceLXl@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1406027485-15657-4-git-send-email-lee.jones@linaro.org>
References: <1406027485-15657-1-git-send-email-lee.jones@linaro.org> <1406027485-15657-4-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:0XO/7qhXgs3X2to3FX1Udc03EDkMcNIyHfhbsuLI9zX
 Y3BOK5zhfGjS9zOy57gbE4c6RZExhkYAgbgN4dX644r4m135PO
 Z48iVXmdFRN5xu2AZMB1SFG4kciKh3gCzON/sF7AAmrUP9NGr0
 W4BoR3P6QMc1UrMW+AMF6LgjlXXkwTOzf6rFZcyYuK/hUiWdUl
 gRt9UO5epLy0EgNZOEpbnHuaw+igFv9+OfuWCRQO0TPmvJ6uB7
 bHcaj6EiuGz32025E1ouBMWaQ4fOJ1yp12mbN5LSUsm3n6EiZF
 KbE3SfnEMZcX+MAWYkUrD909LOHT4VP3jO7qOXrUwrvVY2266g
 zqNXxj+BBIR8Zeh7x4Pg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 July 2014 12:11:09 Lee Jones wrote:
> --- a/drivers/mfd/tps80031.c
> +++ b/drivers/mfd/tps80031.c
> @@ -334,6 +334,7 @@ static bool rd_wr_reg_id1(struct device *dev, unsigned int reg)
>         case TPS80031_PREQ1_RES_ASS_A ... TPS80031_PREQ3_RES_ASS_C:
>         case TPS80031_SMPS_OFFSET ... TPS80031_BATDEBOUNCING:
>         case TPS80031_CFG_INPUT_PUPD1 ... TPS80031_CFG_SMPS_PD:
> +               /* Fall through */
>         case TPS80031_BACKUP_REG:
>                 return true;
>         default:

This one seems to make the code look worse: You are only adding the comment
to one case, not all of them, and it was perfectly understandable
before.

Further, there are a couple of other functions following this one that
also don't have that comment.

It seems checkpatch missed all the other cases because they contain '...'
lists, whereas the one above does not. I think it's better left alone.

	Arnd
