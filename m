Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749Ab3DAUsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 16:48:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45200 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757051Ab3DAUsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 16:48:19 -0400
Message-ID: <5159F27E.7060300@zytor.com>
Date: Mon, 01 Apr 2013 13:47:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] kexec: use Crash kernel for Crash kernel low
References: <20130320163131.GE2273@redhat.com> <1363807329-24975-1-git-send-email-yinghai@kernel.org> <20130325194245.GA7357@redhat.com> <CAE9FiQU6bGSAODX_-Vir6D-LyY-9Sm84rYzq=gNhDZ5whbia_w@mail.gmail.com> <20130326181418.GA6775@redhat.com> <20130401133428.GA13499@redhat.com> <5159D2E9.7080707@zytor.com> <20130401192606.GA17951@redhat.com>
In-Reply-To: <20130401192606.GA17951@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2013 12:26 PM, Vivek Goyal wrote:
> 
> Hi Peter,
> 
> I agree that this dependency on crashkernel is creating lots of problems
> and there should be a better way to manage it.
> 
> Sorry, but I did not fully understand your suggestion on how to handle the
> problem. IIUC, you are suggesting that kexec-tools has the memory
> requirements and when that package installs, it should automatically
> update boot loader command line to communicate that requirement to kernel?
> Or are you suggesting something else entirely.

Yes.  Or rather, kexec-tools should provice a script or utility to
calculate the proper options and let a distribution-specific script add
it to the bootloader configuration.

> Where to reserve is not entirely tied to kexec-tools version. It also
> depends on the environment and run time user options. 

Yes, and the user cannot reasonably be expected to know what that should
be.  You're basically telling the user "guess and pray".

> For example kernel image being loaded and entry point selected. So if one
> decides to load take 32bit entry point of bzImage then memory has to be
> reserved in first 4G (despite the fact that kexec-tools is able to load 64bit
> bzImage and handle higher reserved ranges).
> 
> Also whether to reserve memory for software iotlb will depend on whether
> we have chosen to enable iommu in second kernel or not.
> 
> So sorting out all the memory reservation requirements based on
> kexec-tools version and during installation time alone might not work.
> 
> To make user's life easier, we can probably modify "kdump" service and
> provide another option which can calculate the right crashkernel= command
> line option based on user selected option and system environment and
> display it to user (or possibly propogate to bootloader command line and
> system is rebooted).

Yes, I think we need to so something.

> All this will only address the issue of where to reserve memory. It will
> still not solve the issue of how much memory to reserve. We have no way
> to know. It is all heuristics.

At least heuristics in a script is better than telling the user "guess
and pray".

> crashkernel=<size>,<option>,<option>.. and crashkernel=800M,high sound
> good to me. 
> 
> So atleast for 3.9 kernel, shall we hide new semantics behind
> crashkernel=XM,high and by default crashkernel=XM tries to emulate
> crashkernel=XM,low to retain backward compatibility?

Yes, I suspect so.

	-hpa




