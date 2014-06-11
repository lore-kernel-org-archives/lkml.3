Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbaFKS1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 14:27:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41858 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbaFKS1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 14:27:14 -0400
Message-ID: <53989F7B.6000004@canonical.com>
Date: Wed, 11 Jun 2014 13:27:07 -0500
From: Dave Chiluk <chiluk@canonical.com>
Reply-To: chiluk@canonical.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Rafael Tinoco <rafael.tinoco@canonical.com>, linux-kernel@vger.kernel.org,
        davem@davemloft.net, ebiederm@xmission.com,
        Christopher Arges <chris.j.arges@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: Re: Possible netns creation and execution performance/scalability
 regression since v3.8 due to rcu callbacks being offloaded to multiple cpus
References: <CAJE_dJyfq5zWcs2y52siXRruCCA1Dk_=Ds=rZ8BrBZLa7FCbuQ@mail.gmail.com> <20140611133919.GZ4581@linux.vnet.ibm.com> <CAJE_dJwfaUkop=XZxD-BfDPwKDjnfF1bvmD6XWaqVA4Xt2E6bQ@mail.gmail.com> <539879B8.4010204@canonical.com> <20140611161857.GC4581@linux.vnet.ibm.com>
In-Reply-To: <20140611161857.GC4581@linux.vnet.ibm.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2014 11:18 AM, Paul E. McKenney wrote:
> On Wed, Jun 11, 2014 at 10:46:00AM -0500, David Chiluk wrote:
>> Now think about what happens when a gateway goes down, the namespaces
>> need to be migrated, or a new machine needs to be brought up to replace
>> it.  When we're talking about 3000 namespaces, the amount of time it
>> takes simply to recreate the namespaces becomes very significant.
>>
>> The script is a stripped down example of what exactly is being done on
>> the neutron gateway in order to create namespaces.
> 
> Are the namespaces torn down and recreated one at a time, or is there some
> syscall, ioctl(), or whatever that allows bulk tear down and recreating?
> 
> 							Thanx, Paul

In the normal running case, the namespaces are created one at a time, as
new customers create a new set of VMs on the cloud.

However, in the case of failover to a new neutron gateway the namespaces
are created all at once using the ip command (more or less serially).

As far as I know there is no syscall or ioctl that allows bulk tear down
and recreation.  if such a beast exists that might be helpful.


