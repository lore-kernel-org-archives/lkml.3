Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab3G1Qm0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 12:42:26 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:60072 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab3G1QmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 12:42:25 -0400
Message-ID: <51F54840.3020407@gmail.com>
Date: Sun, 28 Jul 2013 18:35:12 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: O_TMPFILE problem
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm doing a couple of test about O_TMPFILE on my fs. I can see that when 
the file is closed the blocks allocated are not freed. It happens 
because of i_mode, it isn't a regular file nor a directory nor a link. I 
added S_IFREG in my implementation of tmpfile callback when I have to 
call new_inode() and now it works, but am I missing something here?

Marco
