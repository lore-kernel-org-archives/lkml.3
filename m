Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbaENQdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 12:33:09 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22026 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674AbaENQdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 12:33:07 -0400
Message-ID: <53739A9A.5010703@oracle.com>
Date: Wed, 14 May 2014 12:32:26 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>
Subject: Re: perf: use after free in perf_remove_from_context
References: <5370EBE9.6@oracle.com> <20140514162943.GR30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140514162943.GR30445@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 05/14/2014 12:29 PM, Peter Zijlstra wrote:
> On Mon, May 12, 2014 at 11:42:33AM -0400, Sasha Levin wrote:
>> Hi all,
>> 
>> While fuzzing with trinity inside a KVM tools guest running the latest -next kernel I've stumbled on the following spew. Maybe related to the very recent change in freeing on task exit?
>> 
>> [ 2509.827261] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC [ 2509.830379] Dumping ftrace buffer: [ 2509.830379]    (ftrace buffer empty) [ 2509.830379] Modules linked in: [ 2509.830379] CPU: 47 PID: 43306 Comm: trinity-c126 Tainted: G        W     3.15.0-rc5-next-20140512-sasha-00019-ga20bc00-dirty #456
> 
> Any particular trinity setup? And would you happen to have the seed of that run?

Nothing special about trinity options. 400 threads and blacklisting some of the
destructive syscalls (umount, reboot, etc).

I don't have the seed, but that problem did reproduce again tonight so I can test
out debug code if you have something in mind.


Thanks,
Sasha

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTc5qaAAoJEN6mb/eXdyzcg30P/jQ9XyI1kNd82nGwumNkZoxn
7krZU9M0IcUkBcvrxDFgPtdbcEt3p5K+mbF8+fwkwYSGXmKf1MhWaXjB47x74BMg
uM5DNlBTFYU9YRYtHnheb6UNhtIOhU5/oFfmMcGdxWCh/7PdXqrUBMAaAQDa1XJH
y+YBtOZWu+tKXVVuloCJMdgBvh/AI9Hbk/LqUyolKlKOR69A6oK7qFEhQLQpvk4y
63YYCePqLFcc1wYR0zscCnI53jw0qTqOUDo4pPMvWm+i2e9hjSpjDu0Y8drum4hf
nbrr3A8hR4Voy6+z92niEPcpn/N2OeNpijnjUc8YKprl+n2/i+mFx5sUlsAhiWMx
kzboP4yQQHcERuRaL1KJrQAQuWEtUFxLHVIzk0Ou+GrySCQKFCdL1XYO1sc84rOO
3ucDeSaf9lnjYOEHOydHolPzmEZynvGeOGclD5sxzJGrRmvKDuioI/gb5DIKJSLn
1948AukoekAHgFbrZv2ZXV57BtKcuY01cqpOGAfv4/7K8n4FTBgfTLd+1inpqk+n
P+tFzfI+Co+aB6UBHvCRg9Hr5qELjlorYAfVz98Fgvx8uqwbrM3xFCbwjem6qLOq
G2oHHB7/Wzu3GAabaZfwyMcf9jRLDXbgls5NIZ3jpMSt9BX1ezRTmTF4VhHuy51G
4SpXVJGpn/wrUoRygiop
=Fnmx
-----END PGP SIGNATURE-----
