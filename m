Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933155Ab3HNUkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 16:40:35 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:41001 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932912Ab3HNUke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 16:40:34 -0400
Message-ID: <520BEB31.6090103@linux.vnet.ibm.com>
Date: Wed, 14 Aug 2013 15:40:17 -0500
From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Hansen <dave@sr71.net>, Cody P Schafer <cody@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC][PATCH] drivers: base: dynamic memory block creation
References: <1376508705-3188-1-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1376508705-3188-1-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081420-5564-0000-0000-000009450338
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2013 02:31 PM, Seth Jennings wrote:
> Large memory systems (~1TB or more) experience boot delays on the order
> of minutes due to the initializing the memory configuration part of
> sysfs at /sys/devices/system/memory/.

With the previous work that has been done in the memory sysfs layout
I think you need machines with 8 or 16+ TB of memory to see boot delays
that are measured in minutes. The boot delay is there, and with larger
memory systems in he future it will only get worse.

> 
> ppc64 has a normal memory block size of 256M (however sometimes as low
> as 16M depending on the system LMB size), and (I think) x86 is 128M.  With
> 1TB of RAM and a 256M block size, that's 4k memory blocks with 20 sysfs
> entries per block that's around 80k items that need be created at boot
> time in sysfs.  Some systems go up to 16TB where the issue is even more
> severe.
> 

It should also be pointed out that the number of sysfs entries created on
16+ TB system is 100k+. At his scale it is not really human readable to
list all of the entries. The amount of resources used to create all of the
uderlying structures for each of the entries starts to add up also.

I think an approach such as this makes the sysfs memory layout more
human readable and saves on resources.

-Nathan

