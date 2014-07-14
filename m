Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbaGNPyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:54:20 -0400
Received: from mga14.intel.com ([192.55.52.115]:20507 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755783AbaGNPyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:54:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,659,1400050800"; 
   d="scan'208";a="561566221"
From: Andi Kleen <andi@firstfloor.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: [PATCH] vfs: Turn the unlinked inode counter into a percpu counter
References: <1405110219-2969-1-git-send-email-andi@firstfloor.org>
	<alpine.LFD.2.00.1407141022580.13527@localhost.localdomain>
	<20140714154930.GB5803@tassilo.jf.intel.com>
Date: Mon, 14 Jul 2014 08:54:07 -0700
In-Reply-To: <20140714154930.GB5803@tassilo.jf.intel.com> (Andi Kleen's
	message of "Mon, 14 Jul 2014 08:49:30 -0700")
Message-ID: <87wqbgszq8.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@linux.intel.com> writes:
> >  	fsnotify_inode_delete(inode);
>> > -	if (!inode->i_nlink) {
>> > -		WARN_ON(atomic_long_read(&inode->i_sb->s_remove_count) == 0);
>> 
>> This is not mentioned in the description, but I guess it makes sense since
>> it'd be quite expensive.
>
> Yes. I guess we could still check the local counter. I can re-add that.

Actually it's not possible, because the original count could be on
another CPU.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
