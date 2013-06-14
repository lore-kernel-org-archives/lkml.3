Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab3FNQz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:55:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:28929 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163Ab3FNQzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:55:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,867,1363158000"; 
   d="scan'208";a="353539601"
Message-ID: <51BB4B19.6040409@intel.com>
Date: Fri, 14 Jun 2013 09:55:53 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Jan kara <jack@suse.cz>
Subject: Re: ext4 extent status tree LRU locking
References: <51B7B128.60909@intel.com> <20130614140940.GA20401@gmail.com> <51BB3D78.2070907@intel.com> <20130614171116.GB21544@gmail.com>
In-Reply-To: <20130614171116.GB21544@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 10:11 AM, Zheng Liu wrote:
> On Fri, Jun 14, 2013 at 08:57:44AM -0700, Dave Hansen wrote:
>> > On 06/14/2013 07:09 AM, Zheng Liu wrote:
>>> > > -	INIT_LIST_HEAD(&scanned);
>>> > > -
>>> > >  	spin_lock(&sbi->s_es_lru_lock);
>>> > > +	list_sort(NULL, &sbi->s_es_lru, ext4_inode_touch_time_cmp);
>>> > >  	list_for_each_safe(cur, tmp, &sbi->s_es_lru) {
>> > 
>> > How long can this list get?  I have the feeling this might get a bit
>> > painful, especially on a NUMA machine.
> I guess that you worry about the time of sorting a lru list, right?

Yeah, just worried about the amount of time it takes to examine (and
possibly write to) every item on the list.
