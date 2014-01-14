Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbaANCwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 21:52:36 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45236 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaANCwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 21:52:33 -0500
Date: Tue, 14 Jan 2014 02:52:30 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: bug in sscanf()?
Message-ID: <20140114025230.GT10323@ZenIV.linux.org.uk>
References: <804857E1F29AAC47BF68C404FC60A1846542A6B2@ORSMSX105.amr.corp.intel.com>
 <20140113233006.GP10323@ZenIV.linux.org.uk>
 <CA+55aFy_V8ze2CPmHY0Ga-K-DX_SATVu-Tb=_nKq_1Rb5WqaUQ@mail.gmail.com>
 <20140114024725.GS10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140114024725.GS10323@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 02:47:26AM +0000, Al Viro wrote:
> have now.  Something like [completely untested]

And untested it certainly is - at least three missing breaks in there:

> 		case 'H':
> 			STORE(signed char, unsigned char);
> 			break;
> 		case 'h':
> 			STORE(short, unsigned short);
> 			break;
> 		case 'l':
> 			STORE(long, unsigned long);
			break;
> 		case 'L':
> 		case 'j':
> 			STORE(long long, unsigned long long);
			break;
> 		case 'z':
> 		case 'Z':
> 			STORE(long, size_t);
			break;
