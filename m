Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbaFPGBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 02:01:53 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:58430 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbaFPGBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 02:01:52 -0400
Message-ID: <539E8848.3010500@gmail.com>
Date: Mon, 16 Jun 2014 11:31:44 +0530
From: Anil Shashikumar Belur <askb23@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Drokin, Oleg" <oleg.drokin@intel.com>
CC: "Dilger, Andreas" <andreas.dilger@intel.com>,
        "<gregkh@linuxfoundation.org>" <gregkh@linuxfoundation.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<hpdd-discuss@lists.01.org>" <hpdd-discuss@ml01.01.org>
Subject: Re: [PATCH v3 7/7] staging: lustre: lclient: lcommon_cl.c fixing
 coding style issues
References: <1402892916-5298-1-git-send-email-askb23@gmail.com> <1402892916-5298-7-git-send-email-askb23@gmail.com> <6D484D74-443E-4667-9CB8-4F90EC53FB81@intel.com>
In-Reply-To: <6D484D74-443E-4667-9CB8-4F90EC53FB81@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +	unsigned long cur_index;

> I wonder why move this particular declaration here?
> The only user is still in that one conditional branch anyway.
These changes are for fixing warning of line over 80 chars and indent.
maybe I should change 'unsigned long' to 'u64' keeping the line of code
in the same place.
>> 	/*
>> 	 * Consistency guarantees: following possibilities exist for the
>> @@ -864,11 +865,13 @@ int ccc_prep_size(const struct lu_env *env, struct cl_object *obj,
>> 				 * linux-2.6.18-128.1.1 miss to do that.
>> 				 * --bug 17336 */
>> 				loff_t size = cl_isize_read(inode);
>> -				unsigned long cur_index = start >> PAGE_CACHE_SHIFT;
>> +
>> +				cur_index = start >> PAGE_CACHE_SHIFT;
>> +				loff_t check = ((size - 1) >> PAGE_CACHE_SHIFT);
> This used to produce a warning about mixing code and declarations in the past. 
> Probably a bad idea to mix them anyway.
Will create a separate patch for mixed declaration error which is still
present.

