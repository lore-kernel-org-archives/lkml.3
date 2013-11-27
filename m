Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716Ab3K0Ttd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 14:49:33 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:22145 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab3K0Tta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 14:49:30 -0500
Message-ID: <52964C9A.6040305@oracle.com>
Date: Wed, 27 Nov 2013 12:48:42 -0700
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: bhelgaas@google.com, cl91tp@gmail.com, tianyu.lan@intel.com,
        khlebnikov@openvz.org, gnomes@lxorguk.ukuu.org.uk,
        indou.takao@jp.fujitsu.com, jility09@gmail.com, f.otti@gmx.at,
        ebiederm@xmission.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] PCI: Clear Bus Master bit only on kexec reboot
References: <1385579908-24608-1-git-send-email-khalid.aziz@oracle.com> <20131127192420.GC11829@srcf.ucam.org>
In-Reply-To: <20131127192420.GC11829@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2013 12:24 PM, Matthew Garrett wrote:
> On Wed, Nov 27, 2013 at 12:18:28PM -0700, Khalid Aziz wrote:
>
>> +/* flag to track if kexec reboot is in progress */
>> +extern unsigned long kexec_in_progress;
>
> Adding this to pci.h seems a little odd. We may want to use it somewhere
> else at some point. Add it to kexec.h instead?
>

I debated between pci.h and kexec.h but pci-driver.c does not include 
kexec.h and I didn't want to include a whole new file. Now I see another 
problem with adding that extern declaration to pci.h - if CONFIG_KEXEC 
is not set, build will fail. I should add #ifdef CONFIG_KEXEC to the 
code in pci-driver.c as well. Time for v2.

--
Khalid
