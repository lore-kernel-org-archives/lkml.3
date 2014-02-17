Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbaBQXZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 18:25:08 -0500
Received: from mail-am1lp0017.outbound.protection.outlook.com ([213.199.154.17]:30765
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751435AbaBQXZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 18:25:06 -0500
X-Greylist: delayed 896 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Feb 2014 18:25:06 EST
Message-ID: <530296CD.5050503@warwick.ac.uk>
Date: Mon, 17 Feb 2014 23:10:05 +0000
From: Alec Teal <a.teal@warwick.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Torvald Riegel <triegel@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
References: <20140207180216.GP4250@linux.vnet.ibm.com> <1391992071.18779.99.camel@triegel.csb> <CA+55aFwTwCPMpYTL_vCgNNP0hE8s2sgB0iw-79=xoj99V0JUNA@mail.gmail.com> <1392183564.18779.2187.camel@triegel.csb> <20140212180739.GB4250@linux.vnet.ibm.com> <CA+55aFw3S82GYdtnV2nJCvBGcuZf6kXdF5b7Vp9yb21QKr49Jw@mail.gmail.com> <20140213002355.GI4250@linux.vnet.ibm.com> <1392321837.18779.3249.camel@triegel.csb> <20140214020144.GO4250@linux.vnet.ibm.com> <1392352981.18779.3800.camel@triegel.csb> <20140214172920.GQ4250@linux.vnet.ibm.com> <CA+55aFx9CbgrfK4rBVYD75y2KoWiO90dSYsAW83O-tYVLK-gkg@mail.gmail.com> <CA+55aFypfiTFwundih8QEA6ZwVGk=g5L4sabsN0932eih5knOQ@mail.gmail.com> <1392486310.18779.6447.camel@triegel.csb> <CA+55aFwTrt_6m1inNHQkk74i7uPkHNnacwHiBgioZSXieAs5Sw@mail.gmail.com> <1392666947.18779.6838.camel@triegel.csb> <CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
In-Reply-To: <CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [137.205.238.163]
X-ClientProxiedBy: DB4PR01CA004.eurprd01.prod.exchangelabs.com
 (10.242.152.14) To DB3PR01MB188.eurprd01.prod.exchangelabs.com (10.141.3.26)
X-Forefront-PRVS: 012570D5A0
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019001)(6009001)(6049001)(24454002)(51704005)(199002)(377454003)(189002)(479174003)(95416001)(94946001)(83506001)(15975445006)(23676002)(95666001)(54316002)(87976001)(94316002)(81816001)(81686001)(50466002)(46102001)(15202345003)(69226001)(86362001)(54356001)(42186004)(65956001)(93516002)(80022001)(66066001)(76482001)(33656001)(74366001)(53806001)(74876001)(63696002)(64126003)(65806001)(79102001)(19580395003)(83322001)(19580405001)(80316001)(80976001)(81542001)(51856001)(85306002)(74706001)(4396001)(15395725003)(81342001)(56776001)(47976001)(47736001)(49866001)(59766001)(85852003)(92566001)(76796001)(77096001)(47446002)(59896001)(50986001)(77982001)(47776003)(93136001)(74482001)(36756003)(92726001)(76786001)(31966008)(74662001)(74502001)(83072002)(56816005)(90146001);DIR:OUT;SFP:1102;SCL:1;SRVR:DB3PR01MB188;H:[172.29.15.147];CLIP:137.205.238.163;FPR:ECD7F06C.94FAD125.B1F17DB3.44F8FA51.20531;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: warwick.ac.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/02/14 20:18, Linus Torvalds wrote:
> On Mon, Feb 17, 2014 at 11:55 AM, Torvald Riegel<triegel@redhat.com>  wrote:
>> Which example do you have in mind here?  Haven't we resolved all the
>> debated examples, or did I miss any?
> Well, Paul seems to still think that the standard possibly allows
> speculative writes or possibly value speculation in ways that break
> the hardware-guaranteed orderings.
>
> And personally, I can't read standards paperwork. It is invariably
Can't => Don't - evidently.
> written in some basically impossible-to-understand lawyeristic mode,
You mean "unambiguous" - try reading a patent (Apple have 1000s of 
trivial ones, I tried reading one once thinking "how could they have 
phrased it so this got approved", their technique was to make the reader 
want to start cutting themselves to prove they wern't numb to everything)
> and then it is read by people (compiler writers) that intentionally
> try to mis-use the words and do language-lawyering ("that depends on
> what the meaning of 'is' is"). The whole "lvalue vs rvalue expression
> vs 'what is a volatile access'" thing for C++ was/is a great example
> of that.
I'm not going to teach you what rvalues and lvalues, but! 
http://lmgtfy.com/?q=what+are+rvalues might help.
>
> So quite frankly, as a result I refuse to have anything to do with the
> process directly.
Is this goodbye?
>
>                   Linus
That aside, what is the problem? If the compiler has created code that 
that has different program states than what would be created without 
optimisation please file a bug report and/or send something to the 
mailing list USING A CIVIL TONE, there's no need for swear-words and 
profanities all the time - use them when you want to emphasise 
something. Additionally if you are always angry, start calling that 
state "normal" then reserve such words for when you are outraged.

There are so many emails from you bitching about stuff, I've lost track 
of what you're bitching about you bitch that much about it. Like this 
standards stuff above (notice I said stuff, not "crap" or "shit").

What exactly is your problem, if the compiler is doing something the 
standard does not permit, or optimising something wrongly (read: "puts 
the program in a different state than if the optimisation was not 
applied") that is REALLY serious, you are right to report it; but 
whining like a n00b on Stack-overflow when a question gets closed is not 
helping.

I tried reading back though the emails (I dismissed them previously) but 
there's just so much ranting, and rants about the standard too (I would 
trash this if I deemed the effort required to delete was less than the 
storage of the bytes the message takes up) standardised behaviour is 
VERY important.

So start again, what is the serious problem, have you got any code that 
would let me replicate it, what is your version of GCC?

Oh and lastly! Optimisations are not as casual as "oh, we could do this 
and it'd work better" unlike kernel work or any other software that is 
being improved, it is very formal (and rightfully so). I seriously 
recommend you read the first 40 pages at least of a book called 
"Compiler Design, Analysis and Transformation" it's not about the 
parsing phases or anything, but it develops a good introduction and 
later a good foundation for exploring the field further. Compilers do 
not operate on what I call "A-level logic" and to show what I mean I use 
the shovel-to-the-face of real analysis, "of course 1/x tends towards 0, 
it's not gonna be 5!!" = A-level logic. "Let epsilon > 0 be given, then 
there exists an N...." - formal proof. So when one says "the compiler 
can prove" it's not some silly thing powered by A-level logic, it is the 
implementation of something that can be proven to be correct (in the 
sense of the program states mentioned before)

So yeah, calm down and explain - no lashing out at standards bodies, 
what is the problem?

Alec
