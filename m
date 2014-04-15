Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaDOQaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 12:30:39 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:38635 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbaDOQai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 12:30:38 -0400
X-Greylist: delayed 84651 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Apr 2014 12:30:38 EDT
Message-ID: <534D5E02.6030500@hp.com>
Date: Tue, 15 Apr 2014 10:27:46 -0600
From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: T Makphaibulchoke <tmac@hp.com>, tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, aswin@hp.com
Subject: Re: [PATCH v2] fs/ext4: increase parallelism in updating ext4 orphan
 list
References: <1380728283-61038-1-git-send-email-tmac@hp.com> <1396456148-20455-1-git-send-email-tmac@hp.com> <20140402174109.GD8657@quack.suse.cz> <534C135A.9010803@hp.com> <20140414174024.GC13860@quack.suse.cz>
In-Reply-To: <20140414174024.GC13860@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2014 11:40 AM, Jan Kara wrote:
>   Thanks for trying that out! Can you please send me a patch you have been
> testing? Because it doesn't quite make sense to me why using i_mutex should
> be worse than using hashed locks...
>

Thanks again for the comments.

Since i_mutex is also used for serialization in other operations on an inode, in the case that the i_mutex is not held  using it for serialization could cause contention with other operations on the inode.  As the number shows substantial instances of orphan add or delete calls without holding the i_mutex, I presume the performance degradation is due to the contention.

As for the patch, could you please let me know if you need the patch using i_mutex or the patch I'm planning to submit.  If it's the latter, I'm thinking of go ahead and resubmit it.

Thanks,
Mak.

>   OK, at least that makes sense.
> 
> 								Honza
> 

