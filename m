Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab3IEPId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 11:08:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927Ab3IEPIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 11:08:31 -0400
Message-ID: <52289E6C.8090301@redhat.com>
Date: Thu, 05 Sep 2013 11:08:28 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] random, Add user configurable get_bytes_random()
References: <1378383524-27983-1-git-send-email-prarit@redhat.com> <20130905144818.GA23661@thunk.org>
In-Reply-To: <20130905144818.GA23661@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/05/2013 10:48 AM, Theodore Ts'o wrote:
> On Thu, Sep 05, 2013 at 08:18:44AM -0400, Prarit Bhargava wrote:
>> The current code has two exported functions, get_bytes_random() and
>> get_bytes_random_arch().  The first function only calls the entropy
>> store to get random data, and the second only calls the arch specific
>> hardware random number generator.
>>
>> The problem is that no code is using the get_bytes_random_arch() and switching
>> over will require a significant code change.  Even if the change is
>> made it will be static forcing a recompile of code if/when a user has a
>> system with a trusted random HW source.  A better thing to do is allow
>> users to decide whether they trust their hardare random number generator.
> 
> I fail to see the benefit of just using the hardware random number
> generator.  We are already mixing in the hardware random number
> generator into the /dev/random pool, and so the only thing that using

The issue isn't userspace /dev/random as much as it is the use of
get_random_bytes() through out the kernel.  Switching to get_random_bytes_arch()
is a search'n'replace on the entire kernel.  If a user wants the faster random
HW generator why shouldn't they be able to use it by default?

P.

