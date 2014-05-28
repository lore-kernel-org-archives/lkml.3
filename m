Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbaE1VTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:19:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:5385 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbaE1VTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:19:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,930,1392192000"; 
   d="scan'208";a="438252141"
Message-ID: <538652EA.3040606@linux.intel.com>
Date: Wed, 28 May 2014 14:19:38 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Philipp Kern <pkern@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. J. Lu" <hjl.tools@gmail.com>, Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH] x32: Mask away the x32 syscall bit in the ptrace codepath
References: <1401279583-1027-1-git-send-email-pkern@google.com> <53864B66.8030100@amacapital.net> <53864E91.4060207@linux.intel.com> <CALCETrWd9dbBt03u5cpJx+p3D7NeT-d2_=kTg94CRGMq7ji7kQ@mail.gmail.com>
In-Reply-To: <CALCETrWd9dbBt03u5cpJx+p3D7NeT-d2_=kTg94CRGMq7ji7kQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 02:15 PM, Andy Lutomirski wrote:
>>
>>> 3. The OOPS you're fixing doesn't seem like it's fixed.  What if some
>>> other random high bits are set?
>>
>> There is a range check in entry_*.S for the system call.
> 
> I can imagine that causing a certain amount of confusion to fancy
> seccomp users.  Oh, well.  No one that I know of has complained yet.
> 

I don't know how seccomp or audit deal with out-of-range syscall
numbers, so that might be worth taking a look at.

	-hpa


