Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab3AaQpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 11:45:39 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:52409 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab3AaQph convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:10:1>);
	Thu, 31 Jan 2013 11:45:37 -0500
Message-Id: <510AADBE02000078000BB190@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Thu, 31 Jan 2013 16:45:34 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "KY Srinivasan" <kys@microsoft.com>
Cc: "olaf@aepfle.de" <olaf@aepfle.de>, "bp@alien8.de" <bp@alien8.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: RE: [PATCH 2/3] X86: Add a check to catch Xen emulation of
 Hyper-V
References: <1359507077-26050-1-git-send-email-kys@microsoft.com>
 <1359507108-26091-1-git-send-email-kys@microsoft.com>
 <1359507108-26091-2-git-send-email-kys@microsoft.com>
 <5108ED9702000078000BAA08@nat28.tlf.novell.com>
 <1db4d98aa3434d4eab7b36bbeb89cd47@SN2PR03MB061.namprd03.prod.outlook.com>
 <510A2D5802000078000BAEAA@nat28.tlf.novell.com>
 <32e50a43db8849f2944db256989bebb8@SN2PR03MB061.namprd03.prod.outlook.com>
 <fe91cec766464b4fbfeea56d7e5de0a0@SN2PR03MB061.namprd03.prod.outlook.com>
In-Reply-To: <fe91cec766464b4fbfeea56d7e5de0a0@SN2PR03MB061.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 31.01.13 at 16:53, KY Srinivasan <kys@microsoft.com> wrote:
> Are there any published standards in terms of how the CPUID space should be 
> populated in the range from 0x40000000 to 0x40010000. Specifically, unless 

I recall having seen this range being marked as reserved for
hypervisor use somewhere, but I don't remember where that was.

> the standard mandates that all ranges unused by a given hypervisor would 
> return a known value, how can this code be used to detect the presence of an 
> unknown hypervisor. Hyper-V is going to return the Hyper-V string at 
> 0x40000000. So, I was planning to scan starting at 0x40000100. Clearly, I can 
> check for a specific hypervisor that I know causes a problem for Hyper-V (as I 
> have currently done by checking for Xen). How can I check for the presence of 
> yet to be created Hypervisors that may emulate Hyper-V by scanning the CPUID 
> space. I am almost tempted to say that Xen is the special case and the patch 
> I have submitted addresses that. If a new (or existing hypervisor) plans to 
> do what Xen is doing, perhaps we can dissuade them from doing that or we can 
> fix that within the general framework we have here.

I'd simply preset ECX, EDX, and EBX to zero, and check whether
they change on any EAX input divisible by 256, skipping the one
range you know Hyper-V sits in.

Jan

