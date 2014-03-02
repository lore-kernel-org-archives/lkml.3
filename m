Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaCBURL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 15:17:11 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:43330 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbaCBURJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 15:17:09 -0500
Date: Sun, 2 Mar 2014 21:16:58 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Bug in fs/kernfs/dir.c comment or code?
Message-ID: <20140302201656.GA5659@netboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I stumbled across this in fs/kernfs/dir.c:39.

	/* Reserve hash numbers 0, 1 and INT_MAX for magic directory entries */
	if (hash < 1)
		hash += 2;
	if (hash >= INT_MAX)
		hash = INT_MAX - 1;

Shouldn't that be (hash < 2), or is 1 not reserved?

Thanks,
Richard
