Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab3IZThl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 15:37:41 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:29597 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab3IZThk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 15:37:40 -0400
From: "Zuckerman, Boris" <borisz@hp.com>
To: Matthew Wilcox <willy@linux.intel.com>
CC: Vladislav Bolkhovitin <vst@vlnb.net>,
        "rob.gittins@linux.intel.com" <rob.gittins@linux.intel.com>,
        "linux-pmfs@lists.infradead.org" <linux-pmfs@lists.infradead.org>,
        "linux-fsdevel@veger.org" <linux-fsdevel@veger.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: RFC Block Layer Extensions to Support NV-DIMMs
Thread-Topic: RFC Block Layer Extensions to Support NV-DIMMs
Thread-Index: AQHOqblgLk/J+jjSpUS+tHXTE2EoJZm5viyAgBpNQQCAA6zVAIAAfZtwgAA6HgCAABnMQA==
Date: Thu, 26 Sep 2013 19:36:14 +0000
Message-ID: <4C30833E5CDF444D84D942543DF65BDA580690B7@G9W0739.americas.hpqcorp.net>
References: <1378331689.9210.11.camel@Virt-Centos-6.lm.intel.com>
 <522AB5AD.6070206@vlnb.net>
 <1379976688.5886.12.camel@Virt-Centos-6.lm.intel.com>
 <5243DB2A.7090609@vlnb.net>
 <4C30833E5CDF444D84D942543DF65BDA58066A30@G9W0739.americas.hpqcorp.net>
 <20130926175624.GA7422@linux.intel.com>
In-Reply-To: <20130926175624.GA7422@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.14]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I assume that we may have both: CPUs that may have ability to support multiple transactions, CPUs that support only one, CPUs that support none (as today), as well as different devices - transaction capable and not.
So, it seems there is a room for compilers to do their work and for class drivers to do their, right?

boris

> -----Original Message-----
> From: Matthew Wilcox [mailto:willy@linux.intel.com]
> Sent: Thursday, September 26, 2013 1:56 PM
> To: Zuckerman, Boris
> Cc: Vladislav Bolkhovitin; rob.gittins@linux.intel.com; linux-pmfs@lists.infradead.org;
> linux-fsdevel@veger.org; linux-kernel@vger.kernel.org
> Subject: Re: RFC Block Layer Extensions to Support NV-DIMMs
> 
> On Thu, Sep 26, 2013 at 02:56:17PM +0000, Zuckerman, Boris wrote:
> > To work with persistent memory as efficiently as we can work with RAM we need a
> bit more than "commit". It's reasonable to expect that we get some additional
> support from CPUs that goes beyond mfence and mflush. That may include discovery,
> transactional support, etc. Encapsulating that in a special class sooner than later
> seams a right thing to do...
> 
> If it's something CPU-specific, then we wouldn't handle it as part of the "class", we'd
> handle it as an architecture abstraction.  It's only operations which are device-specific
> which would need to be exposed through an operations vector.  For example, suppose
> you buy one device from IBM and another device from HP, and plug them both into
> your SPARC system.  The code you compile needs to run on SPARC, doing whatever
> CPU operations are supported, but if HP and IBM have different ways of handling a
> "commit" operation, we need that operation to be part of an operations vector.
