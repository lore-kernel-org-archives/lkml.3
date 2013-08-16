Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab3HPIxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 04:53:44 -0400
Received: from nm1-vm1.bullet.mail.bf1.yahoo.com ([98.139.213.163]:46417 "EHLO
	nm1-vm1.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754136Ab3HPIxk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 04:53:40 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 256847.87062.bm@omp1020.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=2ZOVwKNP3cEO+PabPp8nvGM6iIWvIZ4ZwndntVhHEWE8yuxyQimBulbYQVzSwUDSFKYZCHqMgHUpmUd1OBd41GMHKyZqKrlMSOsgx0x0O1HpLugy2x/lvl5WxhYis8/ZojyePaTGABFXdtktdI+5ktnPfRfgKLgETxhH7EK7G8c=;
X-YMail-OSG: 0TkOOPIVM1mSceMoMZD40vtSt9aBSmaThNd5G2y5zf_VlX1
 TT29QyJMcnvRrkjUNOlswba.r7HHpy.H2OnFUuXWLOfFyE9BEOlbkn.2hFAz
 L0NzP2z29_Dq_brzWcfgsPhg9FojEKRsVVSf6IzHnGQC7Koa6ARY4ilQBeiP
 zDJ4l2ShIfBePjanuXCvL_vmiAK_LMXSUn6veGg.JdOzTeQn3lqT8ZbVb1x3
 6wugomX2m361VoGTb8VlIZmAVsJwNgEyIzu_A4_lFwzbcJ3Y4LF.Y7.G9UHh
 XiApJsboTff45tN_lVj.8r8HUEz5S4HxlR2cEeJvCMBUISD5NnsYAfxYdN4x
 ow87SPxYUNDet3o5E42uBIFZTVsHBPEudJbmAoJjg88qgHrTLk1T6daaK8ik
 YPxxhzCuDeqjE3qmw95ynX_dvOh3WaQGjTkbGG6h1LttXSYmrSwW54o1pi1t
 nUWffXFFcK5z97Suy81znInMTRg2XG2M0nwlyr_.LX1tqU0UaQab8D0Juf_5
 bIv3Q6fd_u5kH5ajDxqs1a4HS14c5DU93jLePccM8_5r6HVqd0NfVw6zz_3J
 UAg3feo4bZw--
X-Rocket-MIMEInfo: 002.001,aHViLT5ncGlvX2ludG7CoCA9IG9mX2dldF9uYW1lZF9ncGlvKG5wLCAiY29ubmVjdC1ncGlvcyIsIDApOwphbmQKaHViLT5ncGlvX2Nvbm5lY3QgPSBvZl9nZXRfbmFtZWRfZ3BpbyhucCwgImludG4tZ3Bpb3MiLCAwKTsKCkkgZ3Vlc3MgdGhleSBzaG91bGQgYmUgc3dpdGNoZWQgLCB0aGF0IGlzIGNvbm5lY3QtZ3Bpb3MgYm91bmQgdG8gaHViLT5ncGlvX2Nvbm5lY3QKYW5kIGludG4tZ3Bpb3MgdG8gaHViLT5ncGlvX2ludC4KClNvcnJ5IG5vdCB0byBwcm92aWRlcyBhIHBhdGNoLiBJIHRob3VnaHQgdGhhdCABMAEBAQE-
X-Mailer: YahooMailWebService/0.8.154.571
Message-ID: <1376643218.59144.YahooMailNeo@web160103.mail.bf1.yahoo.com>
Date: Fri, 16 Aug 2013 01:53:38 -0700 (PDT)
From: Alban Browaeys <prahal@yahoo.com>
Reply-To: Alban Browaeys <prahal@yahoo.com>
Subject: usb: misc: usb3503: connect and intn mismatch in OF vs variable assignments
To: Dongjin Kim <tobetter@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hub->gpio_intn  = of_get_named_gpio(np, "connect-gpios", 0);
and
hub->gpio_connect = of_get_named_gpio(np, "intn-gpios", 0);

I guess they should be switched , that is connect-gpios bound to hub->gpio_connect
and intn-gpios to hub->gpio_int.

Sorry not to provides a patch. I thought that this issue might ends up with dts relying
on this broken behaviour if not pointed early ...
Either way if not fixed soon , I will have completed my branch cleanup (I also have other patches
to this file ie drivers/usb/misc/usb3503.c).

Best regards
Alban

