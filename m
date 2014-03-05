Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbaCERPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 12:15:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:64744 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbaCERPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 12:15:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,593,1389772800"; 
   d="scan'208";a="494582610"
Message-ID: <53175BB0.1020107@intel.com>
Date: Wed, 05 Mar 2014 09:15:28 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: ecryptfs@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: ecryptfs log spew from EINTR
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a little program that uses mmap() to copy files.  Essentially:

	addr1 = mmap(fd1);
	addr2 = mmap(fd2);
	memcpy(addr1, addr2, len);

If these files are on ecryptfs and I interrupt the memcpy() with ^C, I
consistently get this in dmesg:

ecryptfs_decrypt_page: Error attempting to read lower page; rc = [-4]
ecryptfs_readpage: Error decrypting page; rc = [-4]

-4 is, of course -EINTR because of the ^C.  Should we be suppressing the
message when we see EINTR?
