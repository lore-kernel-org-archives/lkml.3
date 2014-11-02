Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750849AbaKBE7F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 00:59:05 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:43545 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbaKBE7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 00:59:03 -0400
Date: Sun, 2 Nov 2014 10:28:51 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Dan Streetman <ddstreet@ieee.org>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Tyrel Datwyler <tyreld@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Thomas Falcon <tlfalcon@linux.vnet.ibm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Walter <dwalter@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Neil Zhang <zhangwm@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: use device_online/offline() instead of
 cpu_up/down()
Message-ID: <20141102045851.GA8334@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <CALZtONCwrBb+HPY7j7x4R-xmyhajFNCwaS3sns50RMDxHxyiEQ@mail.gmail.com>
 <1414784494-12573-1-git-send-email-ddstreet@ieee.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414784494-12573-1-git-send-email-ddstreet@ieee.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110204-0025-0000-0000-000001A30EE2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 03:41:34PM -0400, Dan Streetman wrote:
> In powerpc pseries platform dlpar operations, Use device_online() and
> device_offline() instead of cpu_up() and cpu_down().
> 
> Calling cpu_up/down directly does not update the cpu device offline
> field, which is used to online/offline a cpu from sysfs.  Calling
> device_online/offline instead keeps the sysfs cpu online value correct.
> The hotplug lock, which is required to be held when calling
> device_online/offline, is already held when dlpar_online/offline_cpu
> are called, since they are called only from cpu_probe|release_store.
> 
> This patch fixes errors on PowerVM systems that have cpu(s) added/removed
> using dlpar operations; without this patch, the
> /sys/devices/system/cpu/cpuN/online nodes do not correctly show the
> online state of added/removed cpus.

Verified the patch to be working as expected when I online and offline
CPUs of a PowerKVM guest using QEMU (plus my RFC hotplug patchset for
QEMU)

Regards,
Bharata.

