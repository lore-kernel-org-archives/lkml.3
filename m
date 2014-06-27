Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbaF0VOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 17:14:52 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53463 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbaF0VOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 17:14:50 -0400
Date: Fri, 27 Jun 2014 23:14:41 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Xie XiuQi <xiexiuqi@huawei.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "Chen, Gong" <gong.chen@linux.intel.com>,
        "joe@perches.com" <joe@perches.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "arozansk@redhat.com" <arozansk@redhat.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Bin <huawei.libin@huawei.com>
Subject: Re: [PATCH v3 4/9] ACPI, x86: Extended error log driver for x86
 platform
Message-ID: <20140627211441.GA20305@nazgul.tnic>
References: <1382084624-10857-1-git-send-email-gong.chen@linux.intel.com>
 <1382084624-10857-5-git-send-email-gong.chen@linux.intel.com>
 <52612BA4.2060906@linux.vnet.ibm.com>
 <53AD0275.7020003@huawei.com>
 <20140627092227.GA23153@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3284BBB1@ORSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3284BBB1@ORSMSX114.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 08:43:14PM +0000, Luck, Tony wrote:
> Not all machine checks are fatal - it would be bad for us to go into
> an infinite spin instead of executing the recovery code.

Then for the time being extlog shouldn't hook into the decoder chain
but into mce_process_work, i.e. the last should call it. Or maybe add
another notifier which is not atomic...
