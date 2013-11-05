Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab3KEBdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 20:33:25 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46646 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab3KEBdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 20:33:24 -0500
Message-ID: <52784ADF.1040104@linux.vnet.ibm.com>
Date: Mon, 04 Nov 2013 17:33:19 -0800
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Andreas Dilger <adilger.kernel@dilger.ca>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] fs/ext3: use rbtree postorder iteration helper instead
 of opencoding
References: <1383345566-25087-1-git-send-email-cody@linux.vnet.ibm.com> <1383345566-25087-6-git-send-email-cody@linux.vnet.ibm.com> <20131104142638.GD8566@quack.suse.cz> <20131105004559.GB24531@quack.suse.cz>
In-Reply-To: <20131105004559.GB24531@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110501-7182-0000-0000-0000090085C6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2013 04:45 PM, Jan Kara wrote:
> On Mon 04-11-13 15:26:38, Jan Kara wrote:
>> On Fri 01-11-13 15:38:50, Cody P Schafer wrote:
>>> Use rbtree_postorder_for_each_entry_safe() to destroy the rbtree instead
>>> of opencoding an alternate postorder iteration that modifies the tree
>>    Thanks. I've merged the patch into my tree.
>    Hum, except that the kernel oopses with this patch. And I think the
> problem is in rbtree_postorder_for_each_entry_safe(). How are those tests
> for NULL supposed to work? For example if the tree is empty, 'pos' will be
> NULL and you'll call rb_next_postorder(&NULL->field) which is pretty much
> guaranteed to oops if 'field' doesn't have offset 0 in the structure...
> 	

You're absolutely right, those NULL checks are wrong when the rb_node 
isn't the first element. Fix incoming shortly.

