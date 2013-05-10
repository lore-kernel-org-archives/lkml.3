Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab3EJUKP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 16:10:15 -0400
Received: from eng.riverbed.com ([208.70.196.45]:64824 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900Ab3EJUKM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 16:10:12 -0400
From: Ming Lei <Ming.Lei@riverbed.com>
To: "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "mchehab@redhat.com" <mchehab@redhat.com>, "bp@alien8.de" <bp@alien8.de>
Subject: RE: x86_mce: mce_start uses number of phsical cores instead of
 logical cores
Thread-Topic: x86_mce: mce_start uses number of phsical cores instead of
 logical cores
Thread-Index: Ac5NnrX+OJKCA1vXQtyGCRlOybefOwACkHHwAAC3qcAAASol0AACAr3g
Date: Fri, 10 May 2013 20:10:10 +0000
Message-ID: <2CE44BD3DBCF9541909CCB42F11CA3921C6FAB06@SFO1EXC-MBXP06.nbttech.com>
References: <2CE44BD3DBCF9541909CCB42F11CA3921C6FAA49@SFO1EXC-MBXP06.nbttech.com>
 <3908561D78D1C84285E8C5FCA982C28F2DA4C92B@ORSMSX106.amr.corp.intel.com>
 <2CE44BD3DBCF9541909CCB42F11CA3921C6FAACA@SFO1EXC-MBXP06.nbttech.com>
 <3908561D78D1C84285E8C5FCA982C28F2DA4C9B9@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F2DA4C9B9@ORSMSX106.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.205.254]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I used intel edac error injector and saw the same problem. I actually wrote down the core numbers and I saw mce got to 0-5 and 12-17, but not the others. I have 2 sockets, 24 logical cores. Below is the trace I put into mce code. The core number is after "#". 

Ming

344 :344  #4 **   802097241816 (207303152230.v1) (207303152334) 4294874599 :24:::::  mce_start do_machine_check
345 :345  #16 **   802097241876 (207303152404.v1) (207303152426) 4294874599 :12:16:1:4:4:  mce_start do_machine_check
346 :346  #0 **   802097241914 (207303152271.v1) (207303152343) 4294874599 :24:::::  mce_start do_machine_check
347 :347  #1 *    802097242074 (207303152515.v1) (207303152599) 4294874599 :8:-4755801206503178081:256:::  mce_no_way_out do_machine_check
348 :348  #13 *    802097242098 (207303152512.v1) (207303152552) 4294874599 :7:::::  mce_no_way_out do_machine_check
349 :349  #3 *    802097242282 (207303152630.v1) (207303152679) 4294874599 :7:::::  mce_no_way_out do_machine_check
350 :350  #14 **   802097242342 (207303152452.v1) (207303152520) 4294874599 :12:16:1:4:4:  mce_start do_machine_check
351 :351  #2 *    802097242366 (207303152458.v1) (207303152537) 4294874599 :8:-4755801206503178081:256:::  mce_no_way_out do_machine_check
352 :352  #0 **   802097242774 (207303152627.v1) (207303152676) 4294874599 :12:16:1:4:4:  mce_start do_machine_check
353 :353  #12 **   802097242838 (207303152829.v1) (207303152853) 4294874599 :24:::::  mce_start do_machine_check
354 :354  #15 **   802097242890 (207303152676.v1) (207303152707) 4294874599 :24:::::  mce_start do_machine_check
355 :355  #4 **   802097243056 (207303152747.v1) (207303152825) 4294874599 :12:16:1:4:4:  mce_start do_machine_check
356 :356  #2 **   802097243386 (207303152881.v1) (207303153006) 4294874599 :24:::::  mce_start do_machine_check
357 :357  #17 **   802097243546 (207303152953.v1) (207303153023) 4294874599 :24:::::  mce_start do_machine_check
358 :358  #5 **   802097243566 (207303152963.v1) (207303153041) 4294874599 :24:::::  mce_start do_machine_check
359 :359  #15 **   802097243922 (207303153107.v1) (207303153193) 4294874599 :12:21:1:9:9:  mce_start do_machine_check
360 :360  #3 *    802097243994 (207303153342.v1) (207303153356) 4294874599 :8:-4755801206503178081:256:::  mce_no_way_out do_machine_check
361 :361  #13 *    802097244074 (207303153175.v1) (207303153242) 4294874599 :8:-4755801206503178081:256:::  mce_no_way_out do_machine_check
362 :362  #1 **   802097244050 (207303153167.v1) (207303153229) 4294874599 :24:::::  mce_start do_machine_check
363 :363  #12 **   802097244174 (207303153212.v1) (207303153284) 4294874599 :12:22:1:9:9:  mce_start do_machine_check
364 :364  #2 **   802097244490 (207303153347.v1) (207303153419) 4294874599 :12:22:1:10:10:  mce_start do_machine_check
365 :365  #1 **   802097244746 (207303153452.v1) (207303153521) 4294874599 :12:22:1:10:10:  mce_start do_machine_check
366 :366  #5 **   802097244834 (207303153488.v1) (207303153558) 4294874599 :12:22:1:10:10:  mce_start do_machine_check
367 :367  #17 **   802097244902 (207303153645.v1) (207303153665) 4294874599 :12:22:1:10:10:  mce_start do_machine_check
368 :368  #3 **   802097245130 (207303153611.v1) (207303153680) 4294874599 :24:::::  mce_start do_machine_check
369 :369  #13 **   802097245302 (207303153681.v1) (207303153760) 4294874599 :24:::::  mce_start do_machine_check
370 :370  #3 **   802097245710 (207303153857.v1) (207303153979) 4294874599 :12:24:1:12:12:  mce_start do_machine_check
371 :371  #13 **   802097246234 (207303154072.v1) (207303154141) 4294874599 :12:24:1:12:12:  mce_start do_machine_check
372 :372  #15 ***  802097246542 (207303154201.v1) (207303154283) 4294874599 :12:5::::  mce_start do_machine_check
373 :373  #3 ***  802097246614 (207303154539.v1) (207303154565) 4294874599 :12:11::::  mce_start do_machine_check
374 :374  #2 ***  802097246678 (207303154265.v1) (207303154331) 4294874599 :12:9::::  mce_start do_machine_check
375 :375  #13 ***  802097246794 (207303154313.v1) (207303154376) 4294874599 :12:12::::  mce_start do_machine_check
376 :376  #1 ***  802097246814 (207303154325.v1) (207303154388) 4294874599 :12:10::::  mce_start do_machine_check
377 :377  #0 ***  802097246898 (207303154350.v1) (207303154420) 4294874599 :12:4::::  mce_start do_machine_check
378 :378  #12 ***  802097246966 (207303154614.v1) (207303154640) 4294874599 :12:6::::  mce_start do_machine_check
379 :379  #4 ***  802097247044 (207303154416.v1) (207303154481) 4294874599 :12:3::::  mce_start do_machine_check
380 :380  #16 ***  802097247064 (207303154429.v1) (207303154494) 4294874599 :12:1::::  mce_start do_machine_check
381 :381  #17 ***  802097247226 (207303154669.v1) (207303154696) 4294874599 :12:7::::  mce_start do_machine_check
382 :382  #14 ***  802097247250 (207303154495.v1) (207303154575) 4294874599 :12:2::::  mce_start do_machine_check
383 :383  #5 ***  802097247574 (207303154632.v1) (207303154666) 4294874599 :12:8::::  mce_start do_machine_check
384 :384  #16 **** 802097247812 (207303154735.v1) (207303154768) 4294874599 :12:1::::  mce_start do_machine_check
385 :385  #16 ***  802097258184 (207303159067.v1) (207303159094) 4294874599 :8:-4755801206503178081:6:::  do_machine_check machine_check
386 :386  #16 *    802097260944 (207303160222.v1) (207303160255) 4294874599 :1:2000000000:1:::  mce_end do_machine_check
387 :387  #14 **** 802097261950 (207303160640.v1) (207303160714) 4294874599 :12:2::::  mce_start do_machine_check
388 :388  #16 **   802097262056 (207303160686.v1) (207303160750) 4294874599 :12:::::  mce_end do_machine_check
389 :389  #14 ***  802097263530 (207303161304.v1) (207303161334) 4294874599 :8:-4755801206503178081:6:::  do_machine_check machine_check
390 :390  #14 *    802097265926 (207303162305.v1) (207303162331) 4294874599 :2:2000000000:2:::  mce_end do_machine_check
391 :391  #4 **** 802097266672 (207303162615.v1) (207303162645) 4294874599 :12:3::::  mce_start do_machine_check
392 :392  #4 ***  802097267796 (207303163087.v1) (207303163119) 4294874599 :8:-4755801206503178081:6:::  do_machine_check machine_check
393 :393  #4 *    802097269420 (207303163764.v1) (207303163794) 4294874599 :3:2000000000:3:::  mce_end do_machine_check
394 :394  #0 **** 802097270254 (207303164111.v1) (207303164139) 4294874599 :12:4::::  mce_start do_machine_check
395 :395  #0 ***  802097271566 (207303164659.v1) (207303164726) 4294874599 :8:-4755801206503178081:6:::  do_machine_check machine_check
396 :396  #0 *    802097273954 (207303165660.v1) (207303165690) 4294874599 :4:2000000000:4:::  mce_end do_machine_check
397 :397  #15 **** 802097275214 (207303166183.v1) (207303166211) 4294874599 :12:5::::  mce_start do_machine_check
398 :398  #15 ***  802097276598 (207303166764.v1) (207303166826) 4294874599 :8:-4755801206503178081:6:::  do_machine_check machine_check
399 :399  #15 *    802097278818 (207303167688.v1) (207303167720) 4294874599 :5:2000000000:5:::  mce_end do_machine_check
400 :400  #12 **** 802097279702 (207303168057.v1) (207303168122) 4294874599 :12:6::::  mce_start do_machine_check


-----Original Message-----
From: Luck, Tony [mailto:tony.luck@intel.com] 
Sent: Friday, May 10, 2013 12:10 PM
To: Ming Lei; linux-kernel@vger.kernel.org
Cc: mchehab@redhat.com; bp@alien8.de
Subject: RE: x86_mce: mce_start uses number of phsical cores instead of logical cores

> With hyperthread turns on, the num_online_cpus reports the number of all logical cores.
> What I found in testing is only half the cores receives the mce broadcast, so I assume only the physical cores get broadcast.

See Intel Software Developer Manual Volume 3B Section 15.10.4.1, 3rd bullet:

   o For processors on which CPUID reports DisplayFamily_DisplayModel as 06H_0EH and onward, an MCA signal is
      broadcast to all logical processors in the system

Your E-5645 processors are a lot newer than this cut-off version - so they should broadcast to all your threads.

You are seeing something very strange.  It would be interesting to know *which* 12 cpus show up for your machine check.  Perhaps you are seeing all the hyperthreads from one socket and none from the other?

I still suspect that something is strange in the EDAC error injection side of this problem and that you are not getting a h/w initiated INT#18 event.

-Tony

