Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbbALO6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 09:58:40 -0500
Received: from exchange10.columbia.tresys.com ([216.30.191.171]:18445 "EHLO
	exchange10.columbia.tresys.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752533AbbALO6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 09:58:38 -0500
X-Greylist: delayed 416 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jan 2015 09:58:38 EST
Message-ID: <54B3DF65.809@tresys.com>
Date: Mon, 12 Jan 2015 09:51:17 -0500
From: "Christopher J. PeBenito" <cpebenito@tresys.com>
Organization: Tresys Technology, LLC
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stephen Smalley <sds@tycho.nsa.gov>, Dave Jones <davej@codemonkey.org.uk>,
        Stephen Smalley <stephen.smalley@gmail.com>,
        Paul Moore <pmoore@redhat.com>, selinux <selinux@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: noisy selinux messages on tmpfs mount.
References: <20150108190822.GB4365@codemonkey.org.uk> <3227891.DhTeT4XeAv@sifl> <2354586.80TRdrKbtf@sifl> <CAB9W1A2nTN2DJ699BXL_r_aXCk-O9-KrTLSi731isQWpPUmkwg@mail.gmail.com> <20150109191329.GA19400@codemonkey.org.uk> <54B03E45.8000106@tycho.nsa.gov>
In-Reply-To: <54B03E45.8000106@tycho.nsa.gov>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/9/2015 3:47 PM, Stephen Smalley wrote:
> On 01/09/2015 02:13 PM, Dave Jones wrote:
>> On Fri, Jan 09, 2015 at 08:06:49AM -0500, Stephen Smalley wrote:
>>  
>>  > On Thu, Jan 8, 2015 at 2:39 PM, Paul Moore <pmoore@redhat.com> wrote:
>>  > > On Thursday, January 08, 2015 02:34:57 PM Paul Moore wrote:
>>  > >> On Thursday, January 08, 2015 02:08:22 PM Dave Jones wrote:
>>  > >> > systemd has started mounting a tmpfs in /run/user/<uid> every time a
>>  > >> > session begins.  So after ssh'ing into a box a number of times, dmesg
>>  > >> > looks like this..
>>  > >> >
>>  > >> > [...] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
>>  > >> > [...] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
>>  > >>
>>  > >> {snip}
>>  > >>
>>  > >> > What's a good solution to stopping this spew ? printk_once doesn't seem
>>  > >> > like a good fit, in case someone is doing different labelling behaviours
>>  > >> > between mounts.
>>  > >> >
>>  > >> > Could we only print it if the mount is being done with non-default
>>  > >> > behaviour perhaps?
>>  > >>
>>  > >> I'm very curious to hear Stephen's opinion on the issue, but I wonder how
>>  > >> much this would honestly impact us if we removed this message in the case
>>  > >> where we mount the filesystem with a known labeling behavior.
>>  >
>>  > We already reduced that message to KERN_DEBUG.  Is that not sufficient?
>>
>> That doesn't really help with the flooding of dmesg, so no.
>> I should also note that it's not just logging in that creates a new
>> session, it also seems to be getting triggered by cron jobs, or
>> whatever the systemd replacement is.
> 
> Fair enough.  I think we can likely get rid of it then.

Are you saying completely get rid of the message in all cases?  If so,
how is a user supposed to debug situations where they mount a filesystem
and labeling doesn't work (i.e. no security label support or policy
hasn't been updated for that fs)?  Is there going to be another place to
look see what the labeling behavior is for all mounted filesystems?

-- 
Chris PeBenito
Tresys Technology, LLC
www.tresys.com | oss.tresys.com
