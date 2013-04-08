Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936400Ab3DHWRW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 18:17:22 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42189 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934846Ab3DHWRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 18:17:20 -0400
Message-ID: <516341ED.5060803@wwwdotorg.org>
Date: Mon, 08 Apr 2013 16:17:17 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Nathan Zimmer <nzimmer@sgi.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Woodhouse <dwmw2@infradead.org>, stable@vger.kernel.org,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: hangs on boot in 9984d7394618df9
References: <515DB465.1060004@sgi.com> <20130404204459.GU21522@ZenIV.linux.org.uk> <515F0456.9040803@sgi.com> <20130405173623.GE4068@ZenIV.linux.org.uk> <515F3A71.9080008@sgi.com> <20130405210042.GH4068@ZenIV.linux.org.uk> <5162E36F.5020305@sgi.com> <20130408155847.GS4068@ZenIV.linux.org.uk> <51632DF8.2080402@sgi.com> <20130408212327.GU4068@ZenIV.linux.org.uk> <20130408214834.GV4068@ZenIV.linux.org.uk>
In-Reply-To: <20130408214834.GV4068@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 03:48 PM, Al Viro wrote:
> On Mon, Apr 08, 2013 at 10:23:27PM +0100, Al Viro wrote:
>> On Mon, Apr 08, 2013 at 03:52:08PM -0500, Nathan Zimmer wrote:
>>
>>> Further digging seems to indicate 9984d7394618df9, the one right
>>> after the commit I previously identified.
>>> Not sure what I did wrong with my bisect to put it off by one.
>>
>> Ugh...  Can't reproduce here ;-/  Could you give more details on your
>> setup?
> 
> Anyway, I've just pushed a splitup of that commit (carved in 3 pieces)
> into vfs.git#pipe-splitup; could you check which part triggers that
> hang?  Should propagate in a few...

It looks like "pipe: unify ->release() and ->open()" introduces the
problem. Note that I had to add a prototype for fifo_open() before the
structs that reference it for that commit to compile.
