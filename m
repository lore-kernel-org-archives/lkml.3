Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab3DMKtT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 06:49:19 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:63278 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab3DMKtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 06:49:18 -0400
Message-ID: <1365850153.9806.59.camel@host5.omatika.ru>
Subject: Re: [PATCH v2] wait while adding MMC host to ensure root mounts
From: Sergey Yanovich <ynvich@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Date: Sat, 13 Apr 2013 14:49:13 +0400
In-Reply-To: <87ppylf429.fsf@octavius.laptop.org>
References: <1363223183-3772-1-git-send-email-ynvich@gmail.com>
	 <1363224194-7366-1-git-send-email-ynvich@gmail.com>
	 <87620jmkoe.fsf@octavius.laptop.org>
	 <CAPDyKFp27MUOjhydLXf92vN3cua=XcX4oTJnMGfOJPpBhtwM8Q@mail.gmail.com>
	 <87ppylf429.fsf@octavius.laptop.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-27 at 07:57 -0400, Chris Ball wrote:
> If the delay's significant, I agree with you and will revert this patch.

The patch was reverted. The problem is back. Filed bug:
https://bugzilla.kernel.org/show_bug.cgi?id=56561

A possible solution is to make card a separate device (now only the host
is a device). In this case, the probing could be done asynchronously
without breaking the assumption in prepare_namespace().

Chris, could you comment?

