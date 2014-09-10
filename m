Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaIJOxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:53:49 -0400
Received: from mga14.intel.com ([192.55.52.115]:60112 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbaIJOxr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:53:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,499,1406617200"; 
   d="scan'208";a="589237373"
From: "Drokin, Oleg" <oleg.drokin@intel.com>
To: Joe Perches <joe@perches.com>
CC: Julia Lawall <julia.lawall@lip6.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "<devel@driverdev.osuosl.org>" <devel@driverdev.osuosl.org>,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>,
        "<kernel-janitors@vger.kernel.org>" <kernel-janitors@vger.kernel.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "Andy Whitcroft" <apw@canonical.com>
Subject: Re: [PATCH] checkpatch: Warn on macros with flow control statements
Thread-Topic: [PATCH] checkpatch: Warn on macros with flow control statements
Thread-Index: AQHPzG4AtdGxJRLQ1EGIjgHETNmIL5v6gvcAgABXSoCAAALvgIAACJAAgAAEgYA=
Date: Wed, 10 Sep 2014 14:52:47 +0000
Message-ID: <7058A061-03C6-4C09-9A82-5F4DADB0FA01@intel.com>
References: <1410106715-9573-6-git-send-email-Julia.Lawall@lip6.fr>
 <20140909125410.GJ6549@mwanda> <1410295093.12560.60.camel@joe-AO725>
 <20140910084306.GV6600@mwanda> <1410357331.24028.39.camel@joe-AO725>
 <alpine.DEB.2.10.1409101604210.4747@hadrien>
 <1410359800.24028.51.camel@joe-AO725>
In-Reply-To: <1410359800.24028.51.camel@joe-AO725>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.119.182]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <F4C4C8CF122ECF479920C6EC7B81015F@intel.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Sep 10, 2014, at 10:36 AM, Joe Perches wrote:

> On Wed, 2014-09-10 at 16:06 +0200, Julia Lawall wrote:
>> On Wed, 10 Sep 2014, Joe Perches wrote:
>>> On Wed, 2014-09-10 at 11:43 +0300, Dan Carpenter wrote:
>>>> On Tue, Sep 09, 2014 at 01:38:13PM -0700, Joe Perches wrote:
>>>>> Macros with flow control statements (goto and return) are
>>>>> not very nice to read as any flow movement is unexpected.
>>> 
>>> break and continue are also flow control statements
>>> but are those are frequently used in macros in
>>> complete switch statements so were not added.
>> 
>> Would it be possible to make a warning when there is a break or continue
>> but no while/switch/etc.
> 
> I suppose the has_flow_statement could be extended.
> 
> Maybe something like:
> 
> 			if ($ctx =~ /\b(goto|return|break|continue)\b/ &&
> 			    $ctx !~ /\b(switch|if|do|while)\b/) {
> 				has_flow_statement = 1;
> 			}
> 
> but checkpatch isn't really capable  of doing proper
> flow logic analysis.

While possibly not really suitable in checkpatch, it might be a good addition to
some static code analyzer as a "future bugs possible due to this" check.

Bye,
    Oleg