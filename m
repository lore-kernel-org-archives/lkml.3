Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999Ab3K0WTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 17:19:00 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:41924 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab3K0WS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 17:18:57 -0500
Message-ID: <52966FA1.3020606@oracle.com>
Date: Wed, 27 Nov 2013 15:18:09 -0700
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>,
        Greg KH <gregkh@linuxfoundation.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, bhelgaas@google.com,
        cl91tp@gmail.com, tianyu.lan@intel.com, khlebnikov@openvz.org,
        gnomes@lxorguk.ukuu.org.uk, indou.takao@jp.fujitsu.com,
        jility09@gmail.com, f.otti@gmx.at, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] PCI: Clear Bus Master bit only on kexec reboot
References: <1385579908-24608-1-git-send-email-khalid.aziz@oracle.com> <87ob55my8z.fsf@xmission.com> <52964F2C.1020803@oracle.com> <20131127212227.GA31237@kroah.com> <20131127215309.GA15320@srcf.ucam.org> <20131127220106.GA21887@kroah.com> <20131127220704.GA15609@srcf.ucam.org>
In-Reply-To: <20131127220704.GA15609@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2013 03:07 PM, Matthew Garrett wrote:
> On Wed, Nov 27, 2013 at 02:01:06PM -0800, Greg KH wrote:
>> Anyway, I really don't care either way, but this seems like something
>> that the drivers should be doing.  What suddenly changed that caused
>> this problem to occur that hasn't happened in the years prior to now
>> that drives this to be a stable-kernel issue?
>
> We started clearing the busmaster bit on all devices on shutdown in
> 3.something in order to ensure that DMA wasn't occuring while we were
> in the process of performing a kexec. Some machines freeze on shutdown
> as a result. This patch reverts back to the original behaviour on real
> shutdown, while still avoiding the "This PCI device scribbled over my
> new kernel" kexec case.
>

Thanks for explaining this, Matthew. That was my reasoning exactly for 
why this patch should apply to stable. It fixes a real problem some 
users are experiencing. Commit log contains the URL to bugzilla entry 
for the problem.

--
Khalid
