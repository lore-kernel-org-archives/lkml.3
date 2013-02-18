Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab3BRFRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 00:17:18 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:52344 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851Ab3BRFRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 00:17:17 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Benson Leung <bleung@chromium.org>
Subject: Re: [PATCH v3 1/1] tools/power x86_energy_perf_policy: fix cpuid for i686
Date: Mon, 18 Feb 2013 00:17:29 -0500
User-Agent: KMail/1.13.7 (Linux/3.7.6; KDE/4.6.5; x86_64; ; )
Cc: len.brown@intel.com, colin.king@canonical.com,
        linux-kernel@vger.kernel.org
References: <1360870558-11711-1-git-send-email-bleung@chromium.org> <1360870558-11711-2-git-send-email-bleung@chromium.org>
In-Reply-To: <1360870558-11711-2-git-send-email-bleung@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2779015.0BQxF84nWE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201302180017.30445.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2779015.0BQxF84nWE
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

On Thursday 14 February 2013 14:35:58 Benson Leung wrote:
> +	asm volatile ("mov %%ebx, %%edi;" /* save ebx (for PIC) */
> +		      "cpuid;"
> +		      "mov %%ebx, %%esi;" /* pass to caller */
> +		      "mov %%edi, %%ebx;" /* restore ebx */
> +		      :"+a" (_eax), "=S" (_ebx), "=c" (_ecx), "=d" (_edx)
> +		      :      /* inputs: eax is handled above */
> +		      :"edi" /* clobbers: we hit edi directly */);

i've written a better version since:
https://github.com/linux-test-project/ltp/blob/master/include/ltp_cpuid.h
-mike

--nextPart2779015.0BQxF84nWE
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJRIblqAAoJEEFjO5/oN/WB5OwQALxK/0FAZDMYda97/2NjTplN
HC6NA0NxtYvMMxleU/OAZUD7hNiykbMAH+EZP/LN5dJeVDD3dzfPd9H3Uxr+gL30
n09gSZb/UqmA7nY0k2PH8HqTz1uJmzRxFAXFX3G4ESDDyrsrxdB0DsRlbxbK18rt
Rjm/iEebilAbUT+kkR8qG0BW4sHOwFQzKzMq4it+TQ1STOcJlqcdkzKhKihXevhO
mDBul0UaStq3vo3OsJx0FdrXVzligfFeLeLW0wBKJlXhhs10aVskL9BF5vqXaFda
j9u/klzIfS/iNHsg/f9lFaKMdyB7w4NMCCZFwevdbbSAoA4IwqduH5ZZqMU83YXs
zLJLgSyr/HiC13ZYf7vqYcpBITbcJqSRkp/mgB6g8N/UtNntw3d3AUhpS61Yl/1C
91HqZBhqMNrFVEEIFzoZquXc7UFYQv9Wd13qpXTGbBLZAf9Ffeh9vqUCL39j4zvG
smoXNImQP+UtL7kqw4tO3fVTVA5UOhYggGIY9DlKEGdKDqAG8K0h41wSl/+retBI
MEDy+uPBsoeAuZUp4GTAgyELQvd3ucuFh8BMR3JDr0w0u0VOFU8bn0fXW62LAkDO
w15QxfpkdMtHtHxQhVx9Y5xZjzbY8hUNw/id4BNk9RrsvlNWLW7QjD84olFyWq3Z
dGkyKpOYMh7lm2cGak3i
=uSn3
-----END PGP SIGNATURE-----

--nextPart2779015.0BQxF84nWE--
