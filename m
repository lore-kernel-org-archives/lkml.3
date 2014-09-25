Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaIYARh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 20:17:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:12740 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbaIYARg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 20:17:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,592,1406617200"; 
   d="scan'208";a="604951306"
From: "Rustad, Mark D" <mark.d.rustad@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] Silence even more W=2 warnings
Thread-Topic: [PATCH 0/7] Silence even more W=2 warnings
Thread-Index: AQHP1B6ZqT8VjyQkzkipcFe03W/rTpwNwlkAgAAZ2ACAABpfgIAABS8AgAAGSQCAAAZEgIAAA7mAgAADVoCAAAa4AIAAFZkAgACwXoCAAJd/AIAAFoIAgAHvRIA=
Date: Thu, 25 Sep 2014 00:17:33 +0000
Message-ID: <ACACCEEA-32F7-4296-B562-C83299BDFAD5@intel.com>
References: <20140922184049.GB4709@pd.tnic>
 <3199350A-89CE-4BE7-8FE4-CA8CE4F87622@intel.com>
 <20140922192152.GD4709@pd.tnic>
 <1411415057.2513.8.camel@jtkirshe-mobl.jf.intel.com>
 <20140922195737.GE4709@pd.tnic>
 <1411416573.2513.19.camel@jtkirshe-mobl.jf.intel.com>
 <20140922203336.GF4709@pd.tnic>
 <A05C31E6-7AD2-482A-B590-A5ED57D028B3@intel.com>
 <20140923082209.GB22072@pd.tnic>
 <029E2CFB-C001-4E16-B1F7-A3FB193E3138@intel.com>
 <20140923184456.GA16467@pd.tnic>
In-Reply-To: <20140923184456.GA16467@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [134.134.176.68]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BCE49CFCCF9B4B4A82A23C069AC13E08@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 23, 2014, at 11:44 AM, Borislav Petkov <bp@alien8.de> wrote:

> Again, we should take compiler warnings with a grain of salt and judge
> them only by the quality of the generated code. IMO.

The more I thought about this, the more I think it argues for having some
diagnostic control macros. Tools such as the compiler can be very thorough -
that is their strength. The warnings that the compiler emits are things
that humans should consider. There are times when the human can judge
that nothing need be done about it, so why not use the macros to indicate
that that judgement has been made and get it out of the way so more
potentially interesting issues can be found? How many people need to
make that judgement over and over? That is clearly a waste of time and
is why these higher warning levels simply don't get looked at. So lets
capture that judgement in the code. That judgement would continue to be
open to reevaluation in any case.

The syscall issue is not arising from an include file, but I think
demonstrates the use nicely and I think is a fine example of a legitimate
use in a C file.

For me, it is about getting more value out of the evaluation that the compiler
can do. When the output of W=2 is unusable because it is so voluminous - filled
with things known to not cause problems - why not silence some of major
sources so that more interesting issues might be seen? By not doing so, W=2
has close to 0 value because no one looks at it.

I guess I also trust the maintainers to not accept lots of patches that add
uses of such macros. They have certainly demonstrated that up to this point.

:-)

-- 
Mark Rustad, Networking Division, Intel Corporation

