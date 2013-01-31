Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab3AaHhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 02:37:51 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:57034 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab3AaHhu convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:10:1>);
	Thu, 31 Jan 2013 02:37:50 -0500
Message-Id: <510A2D5802000078000BAEAA@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Thu, 31 Jan 2013 07:37:44 +0000
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
In-Reply-To: <1db4d98aa3434d4eab7b36bbeb89cd47@SN2PR03MB061.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 30.01.13 at 19:12, KY Srinivasan <kys@microsoft.com> wrote:
> Presumably, Hyper-V emulation is only to run enlightened Windows. The issue 
> with
> Xen is not that it emulates Hyper-V, but this emulation is turned on while 
> running Linux.
> That is the reason I chose to check for Xen. Would you prefer a DMI check 
> for the Hyper-V
> platform. 

I consider DMI checks to be too fragile here - in particular with
the eventual passing through of host DMI attributes to guests,
this sets you up for mistakes. Instead, I would envision you
scanning the whole CPUID range "reserved" for virtualization
(starting at 0x40000000) and see whether you get back
anything other than the Hyper-V identification (much like the
way xen_cpuid_base() scans for the Xen range). Of course
that's under the premise that you're right in assuming Hyper-V
would never emulate any other hypervisor's interface.

Jan

