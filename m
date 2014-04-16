Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbaDPWjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 18:39:47 -0400
Received: from relaygw1-11.mclink.it ([213.21.178.166]:56253 "EHLO
	relaygw1-11.mclink.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbaDPWjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 18:39:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgwFAOEFT1NNK3Ai/2dsb2JhbABZgwY7xS8WdIImAQEEJxM/EAEKISUPSIgZAcoIF45/gw6BFAEDmGUBgTeJMYdhgzM7
Date: Thu, 17 Apr 2014 00:39:42 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: gregkh@linuxfoundation.org
Cc: jet.chen@intel.com, fengguang.wu@intel.com, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] FMC: misc_register should not be called while atomic
Message-ID: <20140416223942.GA2020@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <20140416211007.GA31451@kroah.com>
References: <20140416211007.GA31451@kroah.com>
  <5344BF60.5050300@intel.com>
  <1397016815-74608-1-git-send-email-jet.chen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> --- a/drivers/fmc/fmc-chardev.c
>> +++ b/drivers/fmc/fmc-chardev.c
>> @@ -141,8 +141,8 @@ static int fc_probe(struct fmc_device *fmc)
>>  	fc->misc.fops = &fc_fops;
>>  	fc->misc.name = kstrdup(dev_name(&fmc->dev), GFP_KERNEL);
>>  
>> -	spin_lock(&fc_lock);
>>  	ret = misc_register(&fc->misc);
>> +	spin_lock(&fc_lock);
>>  	if (ret < 0) {
>>  		kfree(fc->misc.name);
>>  		kfree(fc);
>> -- 
>> 1.9.1

This is already applied, though in a slightly different way. Commit
783c2fb1b. I fixed it in Jul 13 2013 after user reports.

"git tag --contains 783c2fb1b" reports v3.12-rc1 and later

/alessandro
