Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbaFQAo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 20:44:29 -0400
Received: from 99-65-72-227.uvs.sntcca.sbcglobal.net ([99.65.72.227]:57668
	"EHLO stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752934AbaFQAo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 20:44:26 -0400
Message-ID: <539F8F62.4000805@chelsio.com>
Date: Mon, 16 Jun 2014 17:44:18 -0700
From: Anish Bhatt <anish@chelsio.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] checkpatch: Warn on unnecessary void function return
 statements
References: <1401728316.5770.9.camel@joe-AO725> <1402961300-17985-1-git-send-email-anish@chelsio.com> <1402964898.11561.2.camel@joe-AO725>
In-Reply-To: <1402964898.11561.2.camel@joe-AO725>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My code has multiple exit lables:
void function(void)
{
	...

	if (err1)
		goto exit1;
	...
	if (err2)
		goto exit2;

	...
	return; /* Good return, no errors */
exit1:
	printk(err1);
	return;
exit2:
	printk(err2);
}

The single tabbed return was required to prevent the good return & err1 
messages cascading down. The extra exit label with a noop looks weird, 
but is passing checkpatch.pl --strict, so I will go with that, thanks.
-Anish

