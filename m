Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbaIIRKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 13:10:55 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:31391 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbaIIRKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 13:10:52 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-cd-540f3498a204
Message-id: <540F3481.5030900@samsung.com>
Date: Tue, 09 Sep 2014 19:10:25 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCHv2 2/3] [media] s5p-jpeg: Fix compilation with COMPILE_TEST
References: <20140909124306.2d5a0d76@canb.auug.org.au>
 <6cbd00c5f2d342b573aaf9c0e533778374dd2e1e.1410273306.git.m.chehab@samsung.com>
 <b7343e6296b5d1d68b7229b8307442fd4141bcb3.1410273306.git.m.chehab@samsung.com>
 <540F15B2.3000902@samsung.com> <20140909120936.527bd852.m.chehab@samsung.com>
 <540F1D11.9030400@samsung.com> <20140909131036.7265121f.m.chehab@samsung.com>
In-reply-to: <20140909131036.7265121f.m.chehab@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t/xy7ozTPhDDG5PE7Povfqc0eLH6wts
	Fr0LrrJZnG16w26x6fE1VovLu+awWfRs2MpqcXBhG6PFjPP7mCwurpO32HFqEbPF1r1X2R14
	PBpv3GDz2LxCy2PzknqPvi2rGD0+b5ILYI3isklJzcksSy3St0vgyvj2t5Gl4CxLxfNFfYwN
	jO+Yuxg5OSQETCSe7zjEBmGLSVy4tx7MFhJYyihxcAprFyMXkP2JUWLl/5XsIAleAS2J6/3X
	mEBsFgFVid4zS8EGsQkYSvQe7WMEsUUFwiSe/TrIBFEvKPFj8j0WEFtEwEDi8aKT7CBDmQWO
	MEtcubINbJuwgJ/Ehu6V7BDbfjBJtG5cBdbNKWAt8f7EFKCpHEAdehL3L2qBhJkF5CU2r3nL
	PIFRYBaSHbMQqmYhqVrAyLyKUTS1NLmgOCk911CvODG3uDQvXS85P3cTIyQivuxgXHzM6hCj
	AAejEg9vQwZfiBBrYllxZe4hRgkOZiURXusXQCHelMTKqtSi/Pii0pzU4kOMTBycUg2MQUdY
	T+RvSV3Ye8T2yFpfs2sMznEJyzRXbXf9ff/99VN6H5a3JzjMMr601taVd5XJ1s+uv755qK0Q
	bIt78k669fypiuVGon4PL4kWL10r6KxmsE3gfm7I/SMch6fPabewNlzjJ3dPX/9qo8psfrOq
	d6+mX1gbuXqtoKP0ajaFHz/msBbYXuupVGIpzkg01GIuKk4EAJ3YwnVmAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/14 18:10, Mauro Carvalho Chehab wrote:
> ERROR: "__bad_ndelay" [drivers/media/platform/s5p-jpeg/s5p-jpeg.ko] undefined!
> 
> That happens because asm-generic doesn't like any ndelay time
> bigger than 20us.
> 
> Currently, usleep_range() couldn't simply be used, since
> exynos4_jpeg_sw_reset() is called with a spinlock held.
> 
> So, let's use ndelay() instead.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

--
Thanks,
Sylwester
