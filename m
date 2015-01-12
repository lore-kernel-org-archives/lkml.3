Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbbALPyg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 10:54:36 -0500
Received: from emvm-gh1-uea08.nsa.gov ([63.239.67.9]:56927 "EHLO
	emvm-gh1-uea08.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbbALPyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 10:54:35 -0500
X-TM-IMSS-Message-ID: <08e5c7620000ad3c@nsa.gov>
Message-ID: <54B3EDF4.2000801@tycho.nsa.gov>
Date: Mon, 12 Jan 2015 10:53:24 -0500
From: Stephen Smalley <sds@tycho.nsa.gov>
Organization: National Security Agency
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Christopher J. PeBenito" <cpebenito@tresys.com>,
        Dave Jones <davej@codemonkey.org.uk>,
        Stephen Smalley <stephen.smalley@gmail.com>,
        Paul Moore <pmoore@redhat.com>, selinux <selinux@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: noisy selinux messages on tmpfs mount.
References: <20150108190822.GB4365@codemonkey.org.uk> <3227891.DhTeT4XeAv@sifl> <2354586.80TRdrKbtf@sifl> <CAB9W1A2nTN2DJ699BXL_r_aXCk-O9-KrTLSi731isQWpPUmkwg@mail.gmail.com> <20150109191329.GA19400@codemonkey.org.uk> <54B03E45.8000106@tycho.nsa.gov> <54B3DF65.809@tresys.com>
In-Reply-To: <54B3DF65.809@tresys.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 09:51 AM, Christopher J. PeBenito wrote:
> On 1/9/2015 3:47 PM, Stephen Smalley wrote:
>> On 01/09/2015 02:13 PM, Dave Jones wrote:
>>> On Fri, Jan 09, 2015 at 08:06:49AM -0500, Stephen Smalley wrote:
>>>  
>>>  > On Thu, Jan 8, 2015 at 2:39 PM, Paul Moore <pmoore@redhat.com> wrote:
>>>  > > On Thursday, January 08, 2015 02:34:57 PM Paul Moore wrote:
>>>  > >> On Thursday, January 08, 2015 02:08:22 PM Dave Jones wrote:
>>>  > >> > systemd has started mounting a tmpfs in /run/user/<uid> every time a
>>>  > >> > session begins.  So after ssh'ing into a box a number of times, dmesg
>>>  > >> > looks like this..
>>>  > >> >
>>>  > >> > [...] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
>>>  > >> > [...] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
>>>  > >>
>>>  > >> {snip}
>>>  > >>
>>>  > >> > What's a good solution to stopping this spew ? printk_once doesn't seem
>>>  > >> > like a good fit, in case someone is doing different labelling behaviours
>>>  > >> > between mounts.
>>>  > >> >
>>>  > >> > Could we only print it if the mount is being done with non-default
>>>  > >> > behaviour perhaps?
>>>  > >>
>>>  > >> I'm very curious to hear Stephen's opinion on the issue, but I wonder how
>>>  > >> much this would honestly impact us if we removed this message in the case
>>>  > >> where we mount the filesystem with a known labeling behavior.
>>>  >
>>>  > We already reduced that message to KERN_DEBUG.  Is that not sufficient?
>>>
>>> That doesn't really help with the flooding of dmesg, so no.
>>> I should also note that it's not just logging in that creates a new
>>> session, it also seems to be getting triggered by cron jobs, or
>>> whatever the systemd replacement is.
>>
>> Fair enough.  I think we can likely get rid of it then.
> 
> Are you saying completely get rid of the message in all cases?  If so,
> how is a user supposed to debug situations where they mount a filesystem
> and labeling doesn't work (i.e. no security label support or policy
> hasn't been updated for that fs)?  Is there going to be another place to
> look see what the labeling behavior is for all mounted filesystems?

In most cases, they can extract the information directly from the policy
via seinfo or their favorite policy tool.  For mountpoint labeling, the
printk in question only tells them that mountpoint labeling was used,
not the specific option and value, so reading /proc/self/mounts is more
informative.  /proc/self/mounts will also tell them whether the
filesystem "supports" labeling via the seclabel option.  So I don't
believe it offers us any information that isn't available elsewhere.


