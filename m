Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbaHALFD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 07:05:03 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:10993 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751008AbaHALFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 07:05:00 -0400
Date: Fri, 1 Aug 2014 19:02:27 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Sudeep Holla <sudeep.holla@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Query] How to pass reboot arguments to secure firmware with
 PSCI spec
Message-ID: <20140801190227.116f4c39@xhacker>
In-Reply-To: <53DB6A18.5050904@arm.com>
References: <20140801180652.72e722be@xhacker>
	<53DB6A18.5050904@arm.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-01_04:2014-08-01,2014-08-01,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1408010141
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sudeep,

On Fri, 1 Aug 2014 03:21:12 -0700
Sudeep Holla <sudeep.holla@arm.com> wrote:

> 
> 
> On 01/08/14 11:06, Jisheng Zhang wrote:
> > Hi Catalin and Will,
> >
> > I noticed that the following commit implement reboot via. PSCI
> > SYSTEM_RESET function. So my question is how to handle the reboot
> > arguments?
> >
> 
> What reboot arguments do you want to handle ?

man 2 reboot

...

int reboot(int magic, int magic2, int cmd, void *arg);

...

I want to pass "void *arg" to secure firmware.


> 
> >
> >> static void psci_sys_reset(enum reboot_mode reboot_mode, const char *cmd)
> >> {
> >>        invoke_psci_fn(PSCI_0_2_FN_SYSTEM_RESET, 0, 0, 0);
> >
> > How to pass cmd to secure firmware?
> >
> 
> What cmd do you want to pass ? The function id is already handled. What
> else do you want to pass ?

the "const char *cmd", usually this is the "abc" if user type "reboot abc"
under shell.

For example, android usually type "reboot recovery", the "recovery" will be
passed to next boot kernel boot args.

> 
> If you see PSCI v0.2 spec, the SYSTEM_RESET and SYSTEM_SHUTDOWN takes no
> parameters.

Yes. I know it. That's why I need your help/suggestions about how to handle
the situation above.

Thanks for your input,
Jisheng
