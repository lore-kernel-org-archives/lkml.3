Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbaA0Sfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 13:35:44 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:27415 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651AbaA0Sfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 13:35:42 -0500
Message-ID: <52E6509E.5080103@hp.com>
Date: Mon, 27 Jan 2014 05:27:10 -0700
From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andreas Dilger <adilger@dilger.ca>, Andi Kleen <andi@firstfloor.org>
CC: T Makphaibulchoke <tmac@hp.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "aswin@hp.com" <aswin@hp.com>
Subject: Re: [PATCH v4 0/3] ext4: increase mbcache scalability
References: <1377186876-57291-1-git-send-email-tmac@hp.com> <1390588288-66930-1-git-send-email-tmac@hp.com> <87fvodcb65.fsf@tassilo.jf.intel.com> <DBA818DD-1C87-4B98-8475-8BB8F00F7DA4@dilger.ca>
In-Reply-To: <DBA818DD-1C87-4B98-8475-8BB8F00F7DA4@dilger.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2014 11:09 PM, Andreas Dilger wrote:
> I think the ext4 block groups are locked with the blockgroup_lock that has about the same number of locks as the number of cores, with a max of 128, IIRC.  See blockgroup_lock.h. 
> 
> While there is some chance of contention, it is also unlikely that all of the cores are locking this area at the same time.  
> 
> Cheers, Andreas
> 


Thanks Andreas for the suggestion. Will try that versus adding just a new private spinlock array in mbcache and compare the performance.

Thanks,
Mak.

