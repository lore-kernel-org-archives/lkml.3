Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbaDONuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:50:14 -0400
Received: from mano-163-35-shared.jabatus.fr ([109.234.163.35]:37991 "EHLO
	mano-163-35-shared.jabatus.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750898AbaDONuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:50:07 -0400
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Apr 2014 09:50:07 EDT
X-MailPropre-MailScanner-From: ecolbus@manux.info
X-MailPropre-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0, required 5, autolearn=not spam)
X-MailPropre-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailPropre-MailScanner-ID: 21CA58F61EFC.A43FC
X-MailPropre-MailScanner-Information: Message sortant - Serveurs o2switch
Message-ID: <534D3762.4010905@manux.info>
Date: Tue, 15 Apr 2014 15:42:58 +0200
From: Emmanuel Colbus <ecolbus@manux.info>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC][5/11][MANUX] Kernel compatibility : major/minor numbers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, back to the filesystem...

In order to associate devices to their files, the Linux kernel uses
their major and minor numbers. However, mine doesn't; instead, I've
attributed myself a single group of values (major=0, minor=0, for both
character-mode and block-mode special files), with the meaning (for the
userspace) "you cannot identify the content of this file based on its
major and minor numbers".

As for my kernel, there is a syscall to associate such files with their
proper peripherals (asper(2)), after which it internally identifies them
using their inode and partition numbers; as for userspace, it has no
choice but to use their names, as usual.

Do you have any objection to my taking of these values?

Emmanuel
