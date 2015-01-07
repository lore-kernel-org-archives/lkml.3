Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933827AbbAGCxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:53:30 -0500
Received: from mail-bl2on0125.outbound.protection.outlook.com ([65.55.169.125]:42898
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933793AbbAGCwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:52:55 -0500
Message-ID: <1420599166.4961.47.camel@freescale.com>
Subject: Re: [PATCH] powerpc/8xx: reduce pressure on TLB due to context
 switches
From: Scott Wood <scottwood@freescale.com>
To: Christophe Leroy <christophe.leroy@c-s.fr>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>,
        "Joakim Tjernlund" <joakim.tjernlund@transmode.se>
Date: Tue, 6 Jan 2015 20:52:46 -0600
In-Reply-To: <20150105151453.E32BD1A4CF3@localhost.localdomain>
References: <20150105151453.E32BD1A4CF3@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BLUPR05CA0062.namprd05.prod.outlook.com (10.141.20.32) To
 BY2PR0301MB0728.namprd03.prod.outlook.com (25.160.63.18)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=scottwood@freescale.com; 
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BY2PR0301MB0728;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR0301MB0728;
X-Forefront-PRVS: 044968D9E1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(377424004)(24454002)(46102003)(50466002)(120916001)(99396003)(122386002)(47776003)(64706001)(23676002)(20776003)(50226001)(89996001)(68736005)(36756003)(31966008)(87976001)(101416001)(40100003)(97736003)(106356001)(62966003)(107046002)(103116003)(33646002)(110136001)(105586002)(4396001)(76176999)(2950100001)(77156002)(21056001)(42186005)(92566001)(50986999)(86362001)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0728;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0728;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2015 02:52:52.6337 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0728
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-05 at 16:14 +0100, Christophe Leroy wrote:
> +		}
> +		__clear_bit(id, stale_map[cpu]);
> +
> +	}

Whitespace

> +
> +	/* Flush the TLB for all contexts */
> +	_tlbil_all();

Can you put a comment in here pointing out that for this to work on SMP,
it needs to be a global invalidation, or at least some indication on
this function that it's not SMP-safe?  I realize there's no SMP 8xx, and
this is only called in place of steal_context_up(), but in case others
think of reusing this elsewhere[1]...

-Scott

[1] It might be helpful on e500 derivatives in virtualized environments
where invalidate-by-PID is expensive, depending on how often stealing
happens there.

