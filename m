Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbaGQArq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 20:47:46 -0400
Received: from mail-yk0-f177.google.com ([209.85.160.177]:35428 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827AbaGQArn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 20:47:43 -0400
Message-ID: <53C71D47.60506@gmail.com>
Date: Wed, 16 Jul 2014 20:48:07 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Matt Turner <mattst88@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        =?UTF-8?B?6JSh5q2j6b6Z?= <zhenglong.cai@cs2c.com.cn>,
        Kevin Hilman <khilman@linaro.org>, Tejun Heo <tj@kernel.org>,
        Fabian Frederick <fabf@skynet.be>, David Howells <dhowells@redhat.com>,
        Peter Foley <pefoley2@pefoley.com>, Eric Paris <eparis@redhat.com>,
        Dwight Engen <dwight.engen@oracle.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/1] rcu: Allow user to ovveride RCU_NOCB_CPU_ALL
 at boot time
References: <1405550289-18020-1-git-send-email-bobby.prani@gmail.com> <20140717002651.GJ8690@linux.vnet.ibm.com>
In-Reply-To: <20140717002651.GJ8690@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 08:26 PM, Paul E. McKenney wrote:
> On Wed, Jul 16, 2014 at 06:38:08PM -0400, Pranith Kumar wrote:
>> A kernel built with RCU_NOCB_CPU_ALL build time option will offload callbacks
>> from all CPUs. The user cannot override this behavior without recompiling the
>> kernel with the RCU_NOCB_CPU_ALL option turned off. 
>>
>> This commit allows the user to override the build-time option by using the
>> rcu_nocbs= boot time option without needing to recompile the kernel.
>>
>> Please note that this is how NO_HZ_FULL_ALL build time option works and this
>> commit makes it work similar to that.
>>
>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

Hi Paul,

> I cannot accept this patch.  For one thing, tick_nohz_init_all() looks
> a bit on the unconditional side when CONFIG_NO_HZ_FULL_ALL=y.  For
> another thing, we really do not want to be handing the user a tool that
> allows CPUs that are nohz_full to not be no-CBs CPUs.  For another thing,

I thought the latest patch does not allow that by ORing the nohz_full and
rcu_nocbs mask. Doesn't it? All nohz_full CPUs will be nocb CPUS. We can mention
this explicitly in the kernel-parameters.txt file.

> if we add this and it turns out to be a bad idea, it will be difficult
> to take it back -- someone somewhere will no doubt have scripted the
> boot parameter.

This option already exists in the kernel when RCU_NOCB_CPU_ALL is not set. The
user can pass in rcu_nocbs= at boot time. I am not sure we are adding anything
new with this patch. 

Most of the distro kernels set RCU_NOCB_CPU_ALL and rightly so, as it is the
suggested and most appropriate option. This patch will make it easier for users
who want to specify nocb CPUs for their needs, without having to recompile the
kernel.

> 
> 							Thanx, Paul
> 
> 

--
Pranith
