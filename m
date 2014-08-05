Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621AbaHEDc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 23:32:29 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48609 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756575AbaHEDcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 23:32:25 -0400
Date: Mon, 04 Aug 2014 20:32:24 -0700 (PDT)
Message-Id: <20140804.203224.1217572032106587680.davem@davemloft.net>
To: andrey.krieger.utkin@gmail.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] arch/sparc/math-emu/math_32.c: drop stray break
 operator
From: David Miller <davem@davemloft.net>
In-Reply-To: <1407185261-1799-1-git-send-email-andrey.krieger.utkin@gmail.com>
References: <1407185261-1799-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 Aug 2014 20:32:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Date: Mon,  4 Aug 2014 23:47:41 +0300

> This commit is a guesswork, but it seems to make sense to drop this
> break, as otherwise the following line is never executed and becomes
> dead code. And that following line actually saves the result of
> local calculation by the pointer given in function argument. So the
> proposed change makes sense if this code in the whole makes sense (but I
> am unable to analyze it in the whole).
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=81641
> Reported-by: David Binderman <dcb314@hotmail.com>
> Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>

Yeah, not putting the condition code result into the register might
cause problems :-)

Thanks for catching this, applied and queued up for -stable.
