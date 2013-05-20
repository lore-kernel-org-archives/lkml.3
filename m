Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100Ab3ETUeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 16:34:13 -0400
Received: from mout.gmx.net ([212.227.15.18]:62355 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756637Ab3ETUeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 16:34:12 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19vGDVICVFvnCAVcZSsMIICRcCNTv4g/aVzg+Tmyq
	BnCh+JSYPyVpGx
Message-ID: <519A88BE.8030309@gmx.de>
Date: Mon, 20 May 2013 22:34:06 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130516 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: fuzz testing lets kernel audit complains in the linkat syscall only
X-Enigmail-Version: 1.6a1pre
Content-Type: multipart/mixed;
 boundary="------------010801050602000202010604"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010801050602000202010604
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

While fuzz testing a 3.9.3 kernel I'm wonder why the kernel audit does complain
about a file in the syscall "unlinkat" - but audit does not complain when that file
was created/modified etc.

If this is intended - please press the delete button now.



Not ? Ok.

At a 32bit stable Gentoo linux with kernel 3.9.3 I got messages like:
kernel: type=1702 audit(1369079376.420:37): op=linkat action=denied pid=13536 comm="trinity-child1" path="/dev" dev="loop0" ino=8146

when I chrooted into a 32bit stable Gentoo Linux image and run a fuzz tester:
$> trinity -C 4 -m -x linkat

(4 childs, monochrome, excluded syscall "linkat" to test only those cases,
where linkat was not directly called by the fuzzer),

The appropriate log entry gives:
$> cat x
[13536] [35] unlinkat(dfd=390, pathname="
���T̫̺̳o̬̜ ì̬͎̲̟nv̖̗̻̣̹̕o͖̗̠̜̤k͍͚̹͖̼e̦̗̪͍̪͍ ̬ͅt̕h̠͙̮͕͓e̱̜̗͙̭ ̥͔̫͙̪͍̣͝ḥi̼̦͈̼v̩̟͚̞͎e͈̟̻͙̦̤-m̷̘̝̱í͚̞̦̳n̝̲̯̙̮͞d̴̺̦͕̫ ̗̭̘͎͖r̞͎̜̜͖͎̫͢ep͇r̝̯̝͖͉͎̺e̴s̥e̵̖̳͉͍̩̗n̢͓̪͕̜̰̠̦t̺̞̰i͟n̮̦̖̟g̮͍̱̻͍̜̳ ̳c̖̮̙̣̰̠̩h̷̗͍̖͙̭͇͈a̧͎̯̹̲̺̫ó̭̞̜̣̯͕s̶̤̮̩̘.̨̻̪̖͔  ̳̭̦̭̭̦̞́I̠͍̮n͇̹̪̬v̴͖̭̗̖o̸k̬̤͓͚̠͍i͜n̛̩̹͉̘̹g͙ ̠̥ͅt̰͖͞h̫̼̪e̟̩̝ ̭̠̲̫͔fe̤͇̝̱e͖̮̠̹̭͖͕l͖̲̘͖̠̪i̢̖͎̮̗̯͓̩n̸̰g̙̱̘̗͚̬ͅ ͍o͍͍̩̮͢f̖͓̦̥ ̘͘c̵̫̱̗͚͓̦h͝a̝͍͍̳̣͖͉o͙̟s̤̞.̙̝̭̣̳̼͟  ̢̻͖͓̬̞̰̦W̮̲̝̼̩̝͖i͖͖͡ͅt̘̯͘h̷̬̖̞̙̰̭̳ ̭̪̕o̥̤̺̝̼̰̯͟ṳ̞̭̤t̨͚̥̗ ̟̺̫̩̤̳̩o̟̰̩̖ͅr̞̘̫̩̼d̡͍̬͎̪̺͚͔e͓͖̝̙r̰͖̲̲̻̠.̺̝̺̟͈  ̣̭T̪̩̼h̥̫̪͔̀e̫̯͜ ̨N̟e͔̤zp̮̭͈̟é͉͈ṛ̹̜̺̭͕d̺̪̜͇͓i̞á͕̹

(the file "x" is attached, it contains the next log line of the next
trinity child too due to a missing new line).

FWIW the used Gentoo linux image is an user mode linux image.
I however just mounted it using the loop device, chrooted into it and
run the fuzzer instead of calling that image with a linux exe.

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--------------010801050602000202010604
Content-Type: text/plain; charset=UTF-8;
 name="x"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="x"

WzEzNTM2XSBbMzVdIHVubGlua2F0KGRmZD0zOTAsIHBhdGhuYW1lPSIKv+zDVMyrzLrMs2/M
rMycIMOszKzNjsyyzJ9udsyWzJfMu8yjzLnMlW/NlsyXzKDMnMyka82NzZrMuc2WzLxlzKbM
l8yqzY3Mqs2NIMyszYV0zJVozKDNmcyuzZXNk2XMscyczJfNmcytIMylzZTMq82ZzKrNjcyj
zZ3huKVpzLzMps2IzLx20onMqcyfzZrMns2OZc2IzJ/Mu82ZzKbMpC1tzLfMmMydzLHDrc2a
zJ7MpsyzbsydzLLMr8yZzK7NnmTMtMy6zKbNlcyrIMyXzK3MmM2OzZZyzJ7NjsyczJzNls2O
zKvNomVwzYdyzJ3Mr8ydzZbNic2OzLplzLRzzKVlzLXMlsyzzYnNjcypzJduzKLNk8yqzZXM
nMywzKDMpnTMusyezLBpzZ9u0onMrsymzJbMn2fMrs2NzLHMu82NzJzMsyDMs2PMlsyuzJnM
o8ywzKDMqWjMt8yXzY3Mls2ZzK3Nh82IYcynzY7Mr8y5zLLMusyrw7PMrcyezJzMo8yvzZVz
zLbMpMyuzKnMmC7MqMy7zKrMls2UICDMs8ytzKbMrcytzKbMnsyBScygzY3Mrm7Nh8y5zKrM
rHbMtM2WzK3Ml8yWb8y4a9KJzKzMpM2TzZrMoM2Nac2cbsybzKnMuc2JzJjMuWfNmSDMoMyl
zYV0zLDNls2eaMyrzLzMqmXMn8ypzJ0gzK3MoMyyzKvNlGZlzKTNh8ydzLFlzZbMrsygzLnM
rc2WzZVszZbMssyYzZbMoMyqacyizJbNjsyuzJfMr82TzKluzLjMsGfMmcyxzJjMl82azKzN
hSDNjW/Njc2NzKnMrs2iZsyWzZPMpsylIMyYzZhjzLXMq8yxzJfNms2TzKZozZ1hzJ3Njc2N
zLPMo82WzYlvzZnMn3PMpMyeLsyZzJ3MrcyjzLPMvM2fICDMosy7zZbNk8yszJ7MsMymV8yu
zLLMncy8zKnMnc2Wac2WzZbNoc2FdMyYzK/NmGjMt8yszJbMnsyZzLDMrcyzIMytzKrMlW/M
pcykzLrMncy8zLDMr82f4bmzzJ7MrcykdMyozZrMpcyXIMyfzLrMq8ypzKTMs8ypb8yfzLDM
qcyWzYVyzJ7MmMyrzKnMvGTMoc2NzKzNjsyqzLrNms2UZc2TzZbMncyZcsywzZbMssyyzLvM
oC7MusydzLrMn82IICDMo8ytVMyqzKnMvGjMpcyrzKrNlMyAZcyrzK/NnCDMqE7Mn2XSic2U
zKR6cMyuzK3NiMyfw6nNic2I4bmbzLnMnMy6zK3NlWTMusyqzJzNh82Tacyew6HNlcy5WzEz
NTM3XSBbMF0gc2V0Z3JvdXBzMTYoZ2lkc2V0c2l6ZT0weDYxZGMyZmUzLCBncm91cGxpc3Q9
NDA5NykgPSAtMSAoT3BlcmF0aW9uIG5vdCBwZXJtaXR0ZWQpCg==
--------------010801050602000202010604--
