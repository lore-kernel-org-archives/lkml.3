Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab3HEO5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 10:57:53 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:33857 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab3HEO5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 10:57:51 -0400
Message-ID: <51FFBD6B.8060201@gmail.com>
Date: Mon, 05 Aug 2013 10:57:47 -0400
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>
Subject: Re: [PATCH 9/9] perf kvm stat report: Add option to analyze specific
 VM
References: <1375473947-64285-1-git-send-email-dsahern@gmail.com> <1375473947-64285-10-git-send-email-dsahern@gmail.com> <51FF4CE2.30703@linux.vnet.ibm.com>
In-Reply-To: <51FF4CE2.30703@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/5/13 2:57 AM, Xiao Guangrong wrote:
> On 08/03/2013 04:05 AM, David Ahern wrote:
>> Add an option to analyze a specific VM within a data file. This
>> allows the collection of kvm events for all VMs and then analyze
>> data for each VM (or set of VMs) individually.
>
> Interesting.
>
> But how can we know which pid is the guest's pid after collecting
> the info. Even if the .data file is moved to another box to do
> off-analyze?
>

Up to the user to be able to leverage the option by collecting what ever 
information is needed to correlate a qemu pid with a guest VM.

I have 2 use cases. In one I have a set of shell scripts for managing VMs:

   Id   Profile            PID     IP Address        Description
   --   ----------------   -----   ---------------   ----------------
   01   ubuntu10           -       172.16.128.51     Ubuntu 10.04 LTS
   02   f12-x86_64         8841    172.16.128.52     Fedora 12, x86_64
   05   f10-i386           -       172.16.128.55     Fedora 10, i386
   07   f16-i386           -       172.16.128.57
   08   f16-x86_64         -       172.16.128.58
   09   rhel5.5-i386       14716   172.16.128.59     RHEL 5.5, i386
   10   f10-x86_64         -       172.16.128.60
   12   rhel47-vm1         -       172.16.128.62     rhel4.7 - 32-bit
   13   f17                -       172.16.128.63     Fedora 17, x86_64
   15   f14                -       172.16.128.65     Fedora 14 - x86_64
   16   f10-ppc            -       172.16.128.66
   17   f12-ppc            -       172.16.128.67
   19   f16-ppc            -       172.16.128.69
   20   f16-i386-2         -       172.16.128.70     clone of f16-i386
   21   f18-controller     29590   172.16.128.71     cloud controller
   22   f18                29541   172.16.128.72     Fedora 18 - x86_64

Collecting that information allows me to correlate kvm data to a VM pid. 
I can collect the events for the system and then analyze for a specific VM.

In the second use case (product based) there are 2 VMs and a different 
qemu binary name (along with command line arguments) for telling them apart.

David
