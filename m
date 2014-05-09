Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037AbaEIQPv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 12:15:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:49929 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630AbaEIQPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 12:15:50 -0400
Date: Fri, 9 May 2014 18:15:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [REGRESSION] funny sched_domain build failure during resume
Message-ID: <20140509161545.GX30445@twins.programming.kicks-ass.net>
References: <20140509160455.GA4486@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jiGx5cYVmJx/T6kL"
Content-Disposition: inline
In-Reply-To: <20140509160455.GA4486@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jiGx5cYVmJx/T6kL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 09, 2014 at 12:04:55PM -0400, Tejun Heo wrote:
> It looks like the allocation is for a temp buffer and there are also
> percpu allocations going on.  Maybe just allocate the buffers on boot
> and keep them around?

Its not a scratch buffer, but we could certainly try and keep it around
over suspend/resume.

I'll try and prod at that on monday.

--jiGx5cYVmJx/T6kL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTbP8qAAoJEHZH4aRLwOS6ijIP/0WHPQcGuXL9C7ruBkhQKI2Q
rlBZcylESzJ18ivNoY+G+a8yRrUy+d5H/SeAHRI4s/IvGQt1cuTRpuuERF1YoJjR
LImogkkVYSiOIyTG41dgHf/lHl4enrgU+MsZnwVbDE8U+/Qep5M54WOYo0K//CIo
Ub3tTkGpQZ/wsvjw85kRdEU6dmzFG6DcyTWAIIJUDzuBPwNQCFOu5rfO/beul7LP
GeLcXXySoFJTdSVDk66Y8si06Nd/8M90anPsppyXT/HBRRLzzZwRBtSejkMwQtqt
lmcrmFzMCoDURfPQkQOTpiH/EXCn640wvpPi1NPhTy8NuMD6DB5L94iYpUdaizL3
gbufWWGeJT97+fqAnx+33JBQ+im1fuAbsUXxXSqy5Wz+3k3MfGQ7aDoiK3Vr+Vb7
9NJrZlBpyFW4mvLZtKloRxf640ciD67Ua7qxeykvc7nF8Wqse0sWC1tKmTc1hboC
b/SBkQvy1vzkE+EgKEK3uI95RFI9kknDZevoIWUfwnjvBPxTXhN9NnIcB44A83IH
2wXOdOKVz9M66R+YRfHQ8hI6btRUpJ24wLv9cJqcXF2V84sP1p31LB647zZwDpbX
XUGUuaTLyYsnH/f4dLm4nVRzvkSd+H+yHCPzpBZA3fiNZJcsCvew2vUzarrSPUtx
oCz4UA7XYAybOc+ZSvaM
=0Qtt
-----END PGP SIGNATURE-----

--jiGx5cYVmJx/T6kL--
