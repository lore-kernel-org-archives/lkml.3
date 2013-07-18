Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab3GREz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 00:55:57 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:48125 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab3GREz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 00:55:56 -0400
Message-ID: <51E77551.7040408@linux.vnet.ibm.com>
Date: Thu, 18 Jul 2013 12:55:45 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: gleb@redhat.com, markus@trippelsdorf.de, mtosatti@redhat.com,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: MMU: avoid fast page fault fixing mmio page fault
References: <1374123157-11142-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
In-Reply-To: <1374123157-11142-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071804-5490-0000-0000-000003D7837D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 12:52 PM, Xiao Guangrong wrote:
> Currently, fast page fault tries to fix mmio page fault when the
> generation number is invalid (spte.gen != kvm.gen) and returns to
> guest to retry the fault since it sees the last spte is nonpresent
> which causes infinity loop
> 
> It can be triggered only on AMD host since the mmio page fault is
> recognized as ept-misconfig

Sorry, It should be "recognized as ept-misconfig on Intel host."

