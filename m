Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab3HEToy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 15:44:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:64233 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754986Ab3HETow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 15:44:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,820,1367996400"; 
   d="scan'208";a="382281875"
Message-ID: <52000268.7050205@linux.intel.com>
Date: Mon, 05 Aug 2013 12:52:08 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [RFC v01 1/3] PowerCap: Documentation
References: <1375466932-11842-1-git-send-email-srinivas.pandruvada@linux.intel.com> <1375466932-11842-2-git-send-email-srinivas.pandruvada@linux.intel.com> <20130805130958.33da86c3@lwn.net>
In-Reply-To: <20130805130958.33da86c3@lwn.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 12:09 PM, Jonathan Corbet wrote:
> On Fri,  2 Aug 2013 11:08:50 -0700
> Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com> wrote:
>
>> +power_uw (rw): Current power counter in micro-watts. Write to this counter
>> +resets the counter to zero. If the counter can not be reset, then this attribute
>> +is read-only.
> Sorry if I'm slow, but... power is an instantaneous quantity, so why would
> you use a counter for it?  And why would you want to reset it to zero?
It is an instantaneous value. When I say counter, either in hardware or 
in driver somewhere,
it is reading energy and using a time delta and continuously updating 
this value.
Reset to zero will allow user space to reset its internal energy counter 
used to calculate power.
Our hardware at this time can only provide energy_uj at this time, added 
power_uw for some future devices.
This was suggested in internal reviews. But based on feedback, we can 
drop this attribute totally,
till we have a device needing this.
> Thanks,
>
> jon
>

